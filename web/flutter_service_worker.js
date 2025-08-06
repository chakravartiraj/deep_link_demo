// High-Performance Flutter Service Worker with Advanced Caching Strategies
const CACHE_NAME = 'deep-link-demo-v2.1.0';
const DATA_CACHE_NAME = 'deep-link-demo-data-v2.1.0';
const FONT_CACHE_NAME = 'deep-link-demo-fonts-v2.1.0';

// Critical resources for immediate caching (cache-first strategy)
const CRITICAL_CACHE_FILES = [
  '/',
  '/index.html',
  '/main.dart.js',
  '/flutter.js',
  '/flutter_bootstrap.js',
  '/flutter_service_worker.js',
  '/manifest.json',
  '/favicon.png',
  '/icons/Icon-192.png',
  '/icons/Icon-512.png',
  '/icons/Icon-maskable-192.png',
  '/icons/Icon-maskable-512.png'
];

// Static assets for on-demand caching
const STATIC_ASSETS = [
  '/assets/fonts/',
  '/assets/packages/',
  '/canvaskit/',
  '/assets/AssetManifest.json',
  '/assets/FontManifest.json'
];

// Performance metrics tracking
let cacheHits = 0;
let cacheMisses = 0;

// Install event - aggressive pre-caching for performance
self.addEventListener('install', (event) => {
  console.log('[ServiceWorker] Install v2.1.0');
  
  event.waitUntil(
    Promise.all([
      // Cache critical resources
      caches.open(CACHE_NAME).then((cache) => {
        console.log('[ServiceWorker] Pre-caching critical resources');
        return cache.addAll(CRITICAL_CACHE_FILES.map(url => {
          return new Request(url, { cache: 'reload' });
        }));
      }),
      
      // Skip waiting to activate immediately
      self.skipWaiting()
    ])
  );
});

// Activate event - clean up old caches and claim clients
self.addEventListener('activate', (event) => {
  console.log('[ServiceWorker] Activate v2.1.0');
  
  event.waitUntil(
    Promise.all([
      // Clean up old caches
      caches.keys().then((keyList) => {
        return Promise.all(
          keyList.map((key) => {
            if (key !== CACHE_NAME && key !== DATA_CACHE_NAME && key !== FONT_CACHE_NAME) {
              console.log('[ServiceWorker] Removing old cache', key);
              return caches.delete(key);
            }
          })
        );
      }),
      
      // Take control immediately
      self.clients.claim()
    ])
  );
});

// Fetch event - intelligent caching with performance optimization
self.addEventListener('fetch', (event) => {
  const request = event.request;
  const url = new URL(request.url);
  
  // Skip non-GET requests
  if (request.method !== 'GET') {
    return;
  }
  
  // Handle different resource types with optimized strategies
  if (url.origin === location.origin) {
    event.respondWith(handleAppResources(request));
  } else if (isFontRequest(url)) {
    event.respondWith(handleFontResources(request));
  } else if (isGoogleFonts(url)) {
    event.respondWith(handleGoogleFonts(request));
  }
});

// App resources - Cache First with network fallback
async function handleAppResources(request) {
  try {
    const cache = await caches.open(CACHE_NAME);
    const cachedResponse = await cache.match(request);
    
    if (cachedResponse) {
      cacheHits++;
      console.log(`[ServiceWorker] Cache hit: ${request.url}`);
      
      // Update cache in background for HTML files
      if (request.url.endsWith('.html') || request.url.endsWith('/')) {
        updateCacheInBackground(request, cache);
      }
      
      return cachedResponse;
    }
    
    // Network request with timeout
    const networkResponse = await fetchWithTimeout(request, 5000);
    cacheMisses++;
    console.log(`[ServiceWorker] Cache miss, fetched: ${request.url}`);
    
    // Cache successful responses
    if (networkResponse && networkResponse.status === 200) {
      const responseToCache = networkResponse.clone();
      cache.put(request, responseToCache);
    }
    
    return networkResponse;
    
  } catch (error) {
    console.error('[ServiceWorker] Fetch failed:', error);
    
    // Return offline fallback for navigation requests
    if (request.mode === 'navigate') {
      const cache = await caches.open(CACHE_NAME);
      return cache.match('/index.html');
    }
    
    throw error;
  }
}

// Font resources - Cache First with long-term storage
async function handleFontResources(request) {
  try {
    const cache = await caches.open(FONT_CACHE_NAME);
    const cachedResponse = await cache.match(request);
    
    if (cachedResponse) {
      cacheHits++;
      return cachedResponse;
    }
    
    const networkResponse = await fetchWithTimeout(request, 8000);
    cacheMisses++;
    
    if (networkResponse && networkResponse.status === 200) {
      cache.put(request, networkResponse.clone());
    }
    
    return networkResponse;
    
  } catch (error) {
    console.error('[ServiceWorker] Font fetch failed:', error);
    throw error;
  }
}

// Google Fonts - Stale While Revalidate
async function handleGoogleFonts(request) {
  try {
    const cache = await caches.open(DATA_CACHE_NAME);
    const cachedResponse = await cache.match(request);
    
    // Return cached version immediately
    if (cachedResponse) {
      cacheHits++;
      
      // Update in background
      fetchAndCache(request, cache);
      return cachedResponse;
    }
    
    // No cache, fetch from network
    const networkResponse = await fetchWithTimeout(request, 6000);
    cacheMisses++;
    
    if (networkResponse && networkResponse.status === 200) {
      cache.put(request, networkResponse.clone());
    }
    
    return networkResponse;
    
  } catch (error) {
    console.error('[ServiceWorker] Google Fonts fetch failed:', error);
    throw error;
  }
}

// Helper functions
function fetchWithTimeout(request, timeout) {
  return Promise.race([
    fetch(request),
    new Promise((_, reject) =>
      setTimeout(() => reject(new Error('Fetch timeout')), timeout)
    )
  ]);
}

async function fetchAndCache(request, cache) {
  try {
    const response = await fetch(request);
    if (response && response.status === 200) {
      cache.put(request, response.clone());
    }
  } catch (error) {
    console.log('[ServiceWorker] Background update failed:', error);
  }
}

async function updateCacheInBackground(request, cache) {
  try {
    const response = await fetch(request);
    if (response && response.status === 200) {
      cache.put(request, response);
    }
  } catch (error) {
    console.log('[ServiceWorker] Background cache update failed:', error);
  }
}

function isFontRequest(url) {
  return /\.(woff|woff2|ttf|otf|eot)$/i.test(url.pathname);
}

function isGoogleFonts(url) {
  return url.hostname === 'fonts.googleapis.com' || url.hostname === 'fonts.gstatic.com';
}

// Performance monitoring
self.addEventListener('message', (event) => {
  if (event.data && event.data.type === 'GET_CACHE_STATS') {
    event.ports[0].postMessage({
      cacheHits,
      cacheMisses,
      hitRate: cacheHits / (cacheHits + cacheMisses)
    });
  }
  
  if (event.data && event.data.type === 'SKIP_WAITING') {
    self.skipWaiting();
  }
});

// Background sync for offline functionality
self.addEventListener('sync', (event) => {
  console.log('[ServiceWorker] Background sync:', event.tag);
  
  if (event.tag === 'cache-cleanup') {
    event.waitUntil(performCacheCleanup());
  }
});

async function performCacheCleanup() {
  try {
    const cacheNames = await caches.keys();
    const deletePromises = cacheNames
      .filter(name => !name.includes('v2.1.0'))
      .map(name => caches.delete(name));
    
    await Promise.all(deletePromises);
    console.log('[ServiceWorker] Cache cleanup completed');
  } catch (error) {
    console.error('[ServiceWorker] Cache cleanup failed:', error);
  }
}

// Push notification handling (future enhancement)
self.addEventListener('push', (event) => {
  const options = {
    body: event.data ? event.data.text() : 'Deep Link Demo update available',
    icon: '/icons/Icon-192.png',
    badge: '/icons/Icon-192.png',
    tag: 'deep-link-notification',
    requireInteraction: true,
    actions: [
      { action: 'open', title: 'Open App' },
      { action: 'dismiss', title: 'Dismiss' }
    ]
  };
  
  event.waitUntil(
    self.registration.showNotification('Deep Link Demo', options)
  );
});

console.log('[ServiceWorker] High-Performance Service Worker v2.1.0 loaded');
