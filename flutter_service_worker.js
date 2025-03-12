'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"canvaskit/skwasm.js": "f2ad9363618c5f62e813740099a80e63",
"canvaskit/skwasm.wasm": "f0dfd99007f989368db17c9abeed5a49",
"canvaskit/skwasm.js.symbols": "80806576fa1056b43dd6d0b445b4b6f7",
"canvaskit/skwasm_st.js": "d1326ceef381ad382ab492ba5d96f04d",
"canvaskit/skwasm_st.wasm": "56c3973560dfcbf28ce47cebe40f3206",
"canvaskit/canvaskit.wasm": "efeeba7dcc952dae57870d4df3111fad",
"canvaskit/skwasm_st.js.symbols": "c7e7aac7cd8b612defd62b43e3050bdd",
"canvaskit/canvaskit.js": "6cfe36b4647fbfa15683e09e7dd366bc",
"canvaskit/canvaskit.js.symbols": "68eb703b9a609baef8ee0e413b442f33",
"canvaskit/chromium/canvaskit.wasm": "64a386c87532ae52ae041d18a32a3635",
"canvaskit/chromium/canvaskit.js": "ba4a8ae1a65ff3ad81c6818fd47e348b",
"canvaskit/chromium/canvaskit.js.symbols": "5a23598a2a8efd18ec3b60de5d28af8f",
"splash/img/light-4x.png": "bd3f04a558a7e865a8204ab7658aa0f8",
"splash/img/dark-3x.png": "16d6e10786f2823d0fce00808684ff60",
"splash/img/light-3x.png": "16d6e10786f2823d0fce00808684ff60",
"splash/img/light-1x.png": "deaece8cd5d75868c332ad7fce0cd39b",
"splash/img/dark-1x.png": "deaece8cd5d75868c332ad7fce0cd39b",
"splash/img/light-2x.png": "4424c0a491eb0d85e6278bb721706155",
"splash/img/dark-2x.png": "4424c0a491eb0d85e6278bb721706155",
"splash/img/dark-4x.png": "bd3f04a558a7e865a8204ab7658aa0f8",
"index.html": "37d6134a43c2de9fdae504f655824818",
"/": "37d6134a43c2de9fdae504f655824818",
"assets/NOTICES": "32b905095f7d1a340184b0dfe4042ce0",
"assets/assets/fonts/SpaceMono-Regular.ttf": "96985f7a507afce5ab786569d2b2368f",
"assets/assets/fonts/Ubuntu-Regular.ttf": "84ea7c5c9d2fa40c070ccb901046117d",
"assets/assets/icon/boldnotification.svg": "b4ba6c4139d898fbd5a42b95fed76b40",
"assets/assets/icon/notification.svg": "3141973ce61973e61dbe44b175883edc",
"assets/assets/icon/chevron.svg": "755f863a3293cb2882b301a27e1d9380",
"assets/assets/icon/zamena.svg": "2624a9af743136802477f75c1cc25a02",
"assets/assets/icon/whale_android.png": "976d3868916fb2cea22751699d13dc1b",
"assets/assets/icon/vuesax_linear_note.svg": "5720c86fcddba7572e5065968cb2ff75",
"assets/assets/icon/vuesax_linear_setting-2.svg": "196156a186248fe478d2647942153c70",
"assets/assets/icon/whale_1f40b.png": "2048258d17b05f7be9c786a957cf9f81",
"assets/assets/icon/setting-2.svg": "3edc1de54172b6e727bec0c3cd023dca",
"assets/assets/icon/vuesax_linear_teacher.svg": "4e37cf86cdd7400885f3ffab99659074",
"assets/assets/icon/whale.png": "96e193d0b7c5a888f45a1f0cc5c0b6a6",
"assets/assets/icon/vuesax_linear_moon.svg": "f7f0b4db979b37e6ed4f11202a4f823b",
"assets/assets/icon/vuesax_linear_location.svg": "4e8fa40629c0aad9a37ca060dd0ab57c",
"assets/assets/icon/vuesax_linear_message-programming.svg": "395623010fb927b9c3622f20cac355da",
"assets/assets/icon/note.svg": "49e1918836fce1b40d2ef88f582854e6",
"assets/assets/icon/link-2.svg": "56754c9f5cb0a99f18d42dd27a7db8ba",
"assets/assets/icon/telegram.svg": "752e31b1dd01fa6b738132953ee06bb8",
"assets/assets/icon/zamena_bold.svg": "50eb27cc10758187b797c6b7865f5a1a",
"assets/assets/icon/autumnleave.png": "c6dcfe79e04aa863a7ee0bd03b5f1991",
"assets/assets/icon/grid_list.svg": "70801210cab31e404624ab72538f4b9f",
"assets/assets/icon/vuesax_linear_sun-2.svg": "810d4603b63c52f1e101952656f99ec4",
"assets/assets/icon/vuesax_linear_send-2.svg": "cd597078aa0818985bb41ac0d4e242f4",
"assets/assets/icon/grid_grid.svg": "9be73625f620072c06776d9118ff5c44",
"assets/assets/icon/heart_outlined.svg": "06f8ac613afc3d8810de492a323b12bc",
"assets/assets/icon/vuesax_linear_award.svg": "45aa348844b4a0a78576d1f622e99bd3",
"assets/assets/icon/heart.svg": "d625c03b282890c0c4394607c6cc7445",
"assets/assets/icon/grid_auto.svg": "c728350d7c74577418de1498fefd2e91",
"assets/assets/icon/snowflake.png": "5cf1916a88b933ad6ad4ac7348bc6aa3",
"assets/assets/icon/teacher.svg": "b51356eb85cb5fe35f257f4d9cb7259a",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/AssetManifest.bin": "c72c09df0406ef036c0a86cff07f85f7",
"assets/fonts/MaterialIcons-Regular.otf": "a3f95581bf36d03fdba4af32c0761622",
"assets/FontManifest.json": "617a7f013847df101c5f6a7041521272",
"assets/AssetManifest.bin.json": "7d67e7dda1a162c8e625e8aaf0f64c39",
"assets/packages/mobkit_dashed_border/images/type2.png": "17a23dec244c3d1bb5b4ae67d7bd48b3",
"assets/packages/mobkit_dashed_border/images/type3.png": "2d50ab9d78a15b2f20012c3b9ea56c46",
"assets/packages/mobkit_dashed_border/images/type1.png": "9f8e612a54622229bd4b97e5357a473c",
"assets/packages/mobkit_dashed_border/images/type4.png": "9250b4ccf17768b5c7d6afcaebadf3f9",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "33b7d9392238c04c131b6ce224e13711",
"assets/packages/o3d/assets/template.html": "24a1f29951029adea5122572451138fc",
"assets/packages/o3d/assets/model-viewer.min.js": "a9dc98f8bf360be897a0898a7395f905",
"assets/AssetManifest.json": "bb2939745218bdd5b62d82f8a6e4605a",
"version.json": "6aa112e7974b79cbd96317fd976a1a8a",
"flutter.js": "76f08d47ff9f5715220992f993002504",
"main.dart.js": "9b5b409c62a0df855c449f542fbba550",
"firebase-messaging-sw.js": "88af76143e5e3b3d1e0d19326c93ce56",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"icons/Icon-192.png": "2506c347f81408b5fd9683626646defd",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"manifest.json": "809ff8b69f358921cf62c5578e75a924",
"favicon.png": "0edcf9b037910956712c5221731e7895",
"flutter_bootstrap.js": "064bec5170e71c3f85ecee64edcdbc40"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"flutter_bootstrap.js",
"assets/AssetManifest.bin.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
