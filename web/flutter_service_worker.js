// Optimized Flutter Service Worker with aggressive caching
const CACHE_NAME = 'deep-link-demo-v1.0.0';
const DATA_CACHE_NAME = 'deep-link-demo-data-v1.0.0';

// Critical resources to cache immediately
const CRITICAL_CACHE_FILES = [
  '/',
  '/index.html',
  '/main.dart.js',
  '/flutter.js',
  '/flutter_service_worker.js',
  '/manifest.json',
  '/icons/Icon-192.png',
  '/icons/Icon-512.png'
];

// Assets to cache on demand
const ASSET_CACHE_FILES = [
  '/favicon.png',
  '/icons/Icon-maskable-192.png',
  '/icons/Icon-maskable-512.png'
];

// Install event - cache critical resources
self.addEventListener('install', (event) => {
  console.log('[ServiceWorker] Install');
  event.waitUntil(
    caches.open(CACHE_NAME)
      .then((cache) => {
        console.log('[ServiceWorker] Pre-caching critical resources');
        return cache.addAll(CRITICAL_CACHE_FILES);
      })
      .then(() => {
        // Force activation of new service worker
        return self.skipWaiting();
      })
  );
});

// Activate event - clean up old caches
self.addEventListener('activate', (event) => {
  console.log('[ServiceWorker] Activate');
  event.waitUntil(
    caches.keys().then((keyList) => {
      return Promise.all(keyList.map((key) => {
        if (key !== CACHE_NAME && key !== DATA_CACHE_NAME) {
          console.log('[ServiceWorker] Removing old cache', key);
          return caches.delete(key);
        }
      }));
    }).then(() => {
      // Take control of all pages immediately
      return self.clients.claim();
    })
  );
});

// Fetch event - implement caching strategies
self.addEventListener('fetch', (event) => {
  const url = new URL(event.request.url);
  
  // Handle Flutter app files with cache-first strategy
  if (url.origin === location.origin) {
    event.respondWith(
      caches.match(event.request)
        .then((response) => {
          if (response) {
            console.log('[ServiceWorker] Cache hit:', event.request.url);
            return response;
          }
          
          console.log('[ServiceWorker] Cache miss, fetching:', event.request.url);
          return fetch(event.request)
            .then((response) => {
              // Check if valid response
              if (!response || response.status !== 200 || response.type !== 'basic') {
                return response;
              }
              
              // Clone response for cache
              const responseToCache = response.clone();
              
              // Determine cache strategy based on file type
              const cacheToUse = isAssetFile(event.request.url) ? DATA_CACHE_NAME : CACHE_NAME;
              
              caches.open(cacheToUse)
                .then((cache) => {
                  cache.put(event.request, responseToCache);
                });
              
              return response;
            })
            .catch((error) => {
              console.log('[ServiceWorker] Fetch failed:', error);
              // Return offline fallback if available
              if (event.request.destination === 'document') {
                return caches.match('/index.html');
              }
              throw error;
            });
        })
    );
  }
  
  // Handle Google Fonts with stale-while-revalidate
  else if (url.origin === 'https://fonts.googleapis.com' || url.origin === 'https://fonts.gstatic.com') {
    event.respondWith(
      caches.match(event.request)
        .then((response) => {
          const fetchPromise = fetch(event.request)
            .then((networkResponse) => {
              if (networkResponse && networkResponse.status === 200) {
                const responseToCache = networkResponse.clone();
                caches.open(DATA_CACHE_NAME)
                  .then((cache) => cache.put(event.request, responseToCache));
              }
              return networkResponse;
            });
          
          return response || fetchPromise;
        })
    );
  }
});

// Helper function to determine if URL is an asset
function isAssetFile(url) {
  const assetExtensions = ['.png', '.jpg', '.jpeg', '.gif', '.svg', '.ico', '.woff', '.woff2', '.ttf'];
  return assetExtensions.some(ext => url.toLowerCase().includes(ext));
}

// Background sync for offline actions (future enhancement)
self.addEventListener('sync', (event) => {
  console.log('[ServiceWorker] Background sync:', event.tag);
  if (event.tag === 'background-sync') {
    event.waitUntil(doBackgroundSync());
  }
});

function doBackgroundSync() {
  // Placeholder for future offline functionality
  return Promise.resolve();
}

// Push notification handling (future enhancement)
self.addEventListener('push', (event) => {
  console.log('[ServiceWorker] Push received');
  const options = {
    body: event.data ? event.data.text() : 'New notification',
    icon: '/icons/Icon-192.png',
    badge: '/icons/Icon-192.png',
    tag: 'deep-link-notification'
  };
  
  event.waitUntil(
    self.registration.showNotification('Deep Link Demo', options)
  );
});

// Message handling for cache updates
self.addEventListener('message', (event) => {
  console.log('[ServiceWorker] Message received:', event.data);
  
  if (event.data && event.data.type === 'SKIP_WAITING') {
    self.skipWaiting();
  }
  
  if (event.data && event.data.type === 'CACHE_UPDATE') {
    event.waitUntil(updateCache());
  }
});

// Function to update cache with new resources
function updateCache() {
  return caches.open(CACHE_NAME)
    .then((cache) => {
      return cache.addAll(CRITICAL_CACHE_FILES);
    });
}
