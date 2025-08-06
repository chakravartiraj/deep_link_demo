// Performance Monitoring and Optimization Script
// This script tracks loading performance and provides insights

(function() {
    'use strict';
    
    // Performance metrics collection
    const performanceMetrics = {
        startTime: performance.now(),
        firstPaint: null,
        firstContentfulPaint: null,
        largestContentfulPaint: null,
        cumulativeLayoutShift: null,
        firstInputDelay: null,
        timeToInteractive: null
    };
    
    // Track Core Web Vitals
    function trackCoreWebVitals() {
        // First Contentful Paint
        if ('PerformanceObserver' in window) {
            const fcpObserver = new PerformanceObserver((list) => {
                const entries = list.getEntries();
                const fcpEntry = entries.find(entry => entry.name === 'first-contentful-paint');
                if (fcpEntry) {
                    performanceMetrics.firstContentfulPaint = fcpEntry.startTime;
                    console.log(`FCP: ${fcpEntry.startTime.toFixed(2)}ms`);
                }
            });
            fcpObserver.observe({ type: 'paint', buffered: true });
            
            // Largest Contentful Paint
            const lcpObserver = new PerformanceObserver((list) => {
                const entries = list.getEntries();
                const lastEntry = entries[entries.length - 1];
                performanceMetrics.largestContentfulPaint = lastEntry.startTime;
                console.log(`LCP: ${lastEntry.startTime.toFixed(2)}ms`);
            });
            lcpObserver.observe({ type: 'largest-contentful-paint', buffered: true });
            
            // Cumulative Layout Shift
            let clsValue = 0;
            const clsObserver = new PerformanceObserver((list) => {
                for (const entry of list.getEntries()) {
                    if (!entry.hadRecentInput) {
                        clsValue += entry.value;
                    }
                }
                performanceMetrics.cumulativeLayoutShift = clsValue;
                console.log(`CLS: ${clsValue.toFixed(4)}`);
            });
            clsObserver.observe({ type: 'layout-shift', buffered: true });
            
            // First Input Delay
            const fidObserver = new PerformanceObserver((list) => {
                const entries = list.getEntries();
                const firstInput = entries[0];
                if (firstInput) {
                    performanceMetrics.firstInputDelay = firstInput.processingStart - firstInput.startTime;
                    console.log(`FID: ${performanceMetrics.firstInputDelay.toFixed(2)}ms`);
                }
            });
            fidObserver.observe({ type: 'first-input', buffered: true });
        }
    }
    
    // Track resource loading performance
    function trackResourcePerformance() {
        window.addEventListener('load', () => {
            const navigation = performance.getEntriesByType('navigation')[0];
            const resources = performance.getEntriesByType('resource');
            
            console.group('🚀 Performance Metrics');
            console.log(`DOM Content Loaded: ${navigation.domContentLoadedEventEnd - navigation.domContentLoadedEventStart}ms`);
            console.log(`Load Complete: ${navigation.loadEventEnd - navigation.loadEventStart}ms`);
            console.log(`Total Load Time: ${navigation.loadEventEnd - navigation.fetchStart}ms`);
            
            // Analyze critical resources
            const criticalResources = resources.filter(resource => 
                resource.name.includes('.js') || 
                resource.name.includes('.css') || 
                resource.name.includes('flutter')
            );
            
            console.log('\n📦 Critical Resources:');
            criticalResources.forEach(resource => {
                const loadTime = resource.responseEnd - resource.fetchStart;
                console.log(`${resource.name.split('/').pop()}: ${loadTime.toFixed(2)}ms`);
            });
            
            console.groupEnd();
        });
    }
    
    // Service Worker performance tracking
    function trackServiceWorkerPerformance() {
        if ('serviceWorker' in navigator && navigator.serviceWorker.controller) {
            const channel = new MessageChannel();
            channel.port1.onmessage = (event) => {
                const stats = event.data;
                console.group('💾 Cache Performance');
                console.log(`Cache Hit Rate: ${(stats.hitRate * 100).toFixed(1)}%`);
                console.log(`Cache Hits: ${stats.cacheHits}`);
                console.log(`Cache Misses: ${stats.cacheMisses}`);
                console.groupEnd();
            };
            
            navigator.serviceWorker.controller.postMessage(
                { type: 'GET_CACHE_STATS' }, 
                [channel.port2]
            );
        }
    }
    
    // Connection quality monitoring
    function trackConnectionQuality() {
        if ('connection' in navigator) {
            const connection = navigator.connection;
            console.group('🌐 Connection Info');
            console.log(`Effective Type: ${connection.effectiveType || 'unknown'}`);
            console.log(`Downlink: ${connection.downlink || 'unknown'} Mbps`);
            console.log(`RTT: ${connection.rtt || 'unknown'}ms`);
            console.log(`Save Data: ${connection.saveData ? 'enabled' : 'disabled'}`);
            console.groupEnd();
            
            // Adapt loading strategy based on connection
            if (connection.saveData || connection.effectiveType === 'slow-2g') {
                document.documentElement.classList.add('optimize-for-slow-connection');
            }
        }
    }
    
    // Performance recommendations
    function generateRecommendations() {
        setTimeout(() => {
            const recommendations = [];
            
            if (performanceMetrics.firstContentfulPaint > 1800) {
                recommendations.push('⚡ Consider optimizing critical rendering path');
            }
            
            if (performanceMetrics.largestContentfulPaint > 2500) {
                recommendations.push('🖼️ Optimize largest contentful paint element');
            }
            
            if (performanceMetrics.cumulativeLayoutShift > 0.1) {
                recommendations.push('📐 Reduce layout shifts for better stability');
            }
            
            if (performanceMetrics.firstInputDelay > 100) {
                recommendations.push('⚡ Optimize JavaScript execution for faster interactivity');
            }
            
            if (recommendations.length > 0) {
                console.group('💡 Performance Recommendations');
                recommendations.forEach(rec => console.log(rec));
                console.groupEnd();
            } else {
                console.log('🎉 Excellent performance! All metrics within recommended thresholds.');
            }
        }, 5000);
    }
    
    // Initialize performance tracking
    function initPerformanceTracking() {
        trackCoreWebVitals();
        trackResourcePerformance();
        trackConnectionQuality();
        
        // Delayed tracking for service worker and recommendations
        setTimeout(() => {
            trackServiceWorkerPerformance();
            generateRecommendations();
        }, 2000);
    }
    
    // Start tracking when DOM is ready
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', initPerformanceTracking);
    } else {
        initPerformanceTracking();
    }
    
    // Export metrics for external use
    window.performanceMetrics = performanceMetrics;
    
})();
