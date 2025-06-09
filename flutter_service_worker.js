'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"firebase-messaging-sw.js": "4994f7ed857772219a08367d43e2e829",
"icons/icon180ios.png": "52d324f8f13a29d361f57a54f35f0987",
"icons/Icon-maskable-192.png": "11100f3d75b8f726e596ac1353b7323e",
"icons/Icon-192.png": "2506c347f81408b5fd9683626646defd",
"icons/Icon-maskable-512.png": "e7e158bd1048992145fb3b9100876ebe",
"icons/Icon-512.png": "e7e158bd1048992145fb3b9100876ebe",
"icons/logo.png": "28e89bd8ec9d23c7c322d3b3ef2652f5",
"assets/fonts/MaterialIcons-Regular.otf": "d5491432317cf2e97ef7e098bccfe8a7",
"assets/AssetManifest.bin.json": "352f2bfdd69d9e45e4c05beccbbb3a01",
"assets/AssetManifest.bin": "ffcd284e48187509a46c5fe64b26d3b0",
"assets/AssetManifest.json": "15d3ac6704c6ebfda73b092e98473d8c",
"assets/assets/fonts/SpaceMono-Regular.ttf": "96985f7a507afce5ab786569d2b2368f",
"assets/assets/fonts/Ubuntu-Regular.ttf": "84ea7c5c9d2fa40c070ccb901046117d",
"assets/assets/icon/rustore.svg": "dcd99a7d1d63d476127feabde316625f",
"assets/assets/icon/heart.svg": "d625c03b282890c0c4394607c6cc7445",
"assets/assets/icon/link-2.svg": "56754c9f5cb0a99f18d42dd27a7db8ba",
"assets/assets/icon/note.svg": "49e1918836fce1b40d2ef88f582854e6",
"assets/assets/icon/vuesax_linear_teacher.svg": "4e37cf86cdd7400885f3ffab99659074",
"assets/assets/icon/vuesax_linear_message-programming.svg": "395623010fb927b9c3622f20cac355da",
"assets/assets/icon/vuesax_linear_sun-2.svg": "810d4603b63c52f1e101952656f99ec4",
"assets/assets/icon/teacher.svg": "b51356eb85cb5fe35f257f4d9cb7259a",
"assets/assets/icon/boldnotification.svg": "b4ba6c4139d898fbd5a42b95fed76b40",
"assets/assets/icon/telegram.svg": "752e31b1dd01fa6b738132953ee06bb8",
"assets/assets/icon/vuesax_linear_setting-2.svg": "196156a186248fe478d2647942153c70",
"assets/assets/icon/reverse.svg": "4ffe5a71fee2d66706e1a88f71ab0129",
"assets/assets/icon/zamena.svg": "2624a9af743136802477f75c1cc25a02",
"assets/assets/icon/trash.svg": "9ee1ac860b8b4691a3ea75e4c3b31fde",
"assets/assets/icon/notification.svg": "3141973ce61973e61dbe44b175883edc",
"assets/assets/icon/whale.png": "96e193d0b7c5a888f45a1f0cc5c0b6a6",
"assets/assets/icon/location_bold.svg": "7eeceb149135f4ebe0e3ebd8d28784d1",
"assets/assets/icon/computer.svg": "2c41d4dc2a0962d83bd126d842da0c9f",
"assets/assets/icon/stats.svg": "0c5c8f231d9e05886cfb2f91fd25e56c",
"assets/assets/icon/grid_grid.svg": "9be73625f620072c06776d9118ff5c44",
"assets/assets/icon/vuesax_linear_send-2.svg": "cd597078aa0818985bb41ac0d4e242f4",
"assets/assets/icon/whale_1f40b.png": "2048258d17b05f7be9c786a957cf9f81",
"assets/assets/icon/vuesax_linear_award.svg": "45aa348844b4a0a78576d1f622e99bd3",
"assets/assets/icon/heart_outlined.svg": "06f8ac613afc3d8810de492a323b12bc",
"assets/assets/icon/grid_list.svg": "70801210cab31e404624ab72538f4b9f",
"assets/assets/icon/chevron.svg": "755f863a3293cb2882b301a27e1d9380",
"assets/assets/icon/general.svg": "4b59b808fd2c3431a141ef55787ee347",
"assets/assets/icon/econom.svg": "c422a96436a6215e56d76a53e7917ec3",
"assets/assets/icon/grid_auto.svg": "c728350d7c74577418de1498fefd2e91",
"assets/assets/icon/vuesax_linear_moon.svg": "f7f0b4db979b37e6ed4f11202a4f823b",
"assets/assets/icon/vuesax_linear_location.svg": "4e8fa40629c0aad9a37ca060dd0ab57c",
"assets/assets/icon/brush_bold.svg": "3a9cc38bd50c676c103303ddde7ec5d7",
"assets/assets/icon/snowflake.png": "5cf1916a88b933ad6ad4ac7348bc6aa3",
"assets/assets/icon/informatics.svg": "ae405352cbbafb210e87a3b37f98d823",
"assets/assets/icon/zamena_bold.svg": "50eb27cc10758187b797c6b7865f5a1a",
"assets/assets/icon/vuesax_linear_note.svg": "5720c86fcddba7572e5065968cb2ff75",
"assets/assets/icon/excel.svg": "db639ef0c4e33b03adb524088dc2d43d",
"assets/assets/icon/autumnleave.png": "c6dcfe79e04aa863a7ee0bd03b5f1991",
"assets/assets/icon/whale_android.png": "976d3868916fb2cea22751699d13dc1b",
"assets/assets/icon/setting-2.svg": "3edc1de54172b6e727bec0c3cd023dca",
"assets/assets/icon/brush.svg": "646f2bc68c86a10f1881452fc3058263",
"assets/assets/icon/export.svg": "8c5a2bbd7df132f059c720f4b1c7697e",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "33b7d9392238c04c131b6ce224e13711",
"assets/packages/syncfusion_flutter_datepicker/assets/fonts/Roboto-Medium.ttf": "7d752fb726f5ece291e2e522fcecf86d",
"assets/packages/mobkit_dashed_border/images/type4.png": "9250b4ccf17768b5c7d6afcaebadf3f9",
"assets/packages/mobkit_dashed_border/images/type1.png": "9f8e612a54622229bd4b97e5357a473c",
"assets/packages/mobkit_dashed_border/images/type3.png": "2d50ab9d78a15b2f20012c3b9ea56c46",
"assets/packages/mobkit_dashed_border/images/type2.png": "17a23dec244c3d1bb5b4ae67d7bd48b3",
"assets/packages/o3d/assets/template.html": "24a1f29951029adea5122572451138fc",
"assets/packages/o3d/assets/model-viewer.min.js": "a9dc98f8bf360be897a0898a7395f905",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/FontManifest.json": "617a7f013847df101c5f6a7041521272",
"assets/NOTICES": "1062f5b99eec26014c63bc7d54e4ef81",
"main.dart.js": "a6e263cfe46bb749b25b67bfeaabc9ff",
"manifest.json": "ee5c8a419ab07e3df00ac27c45b3e591",
"version.json": "0378a44e9b85432f1ad0648cd52e6920",
"canvaskit/skwasm.js.symbols": "e72c79950c8a8483d826a7f0560573a1",
"canvaskit/canvaskit.js": "728b2d477d9b8c14593d4f9b82b484f3",
"canvaskit/skwasm.wasm": "39dd80367a4e71582d234948adc521c0",
"canvaskit/canvaskit.wasm": "7a3f4ae7d65fc1de6a6e7ddd3224bc93",
"canvaskit/canvaskit.js.symbols": "bdcd3835edf8586b6d6edfce8749fb77",
"canvaskit/skwasm.js": "ea559890a088fe28b4ddf70e17e60052",
"canvaskit/chromium/canvaskit.js": "8191e843020c832c9cf8852a4b909d4c",
"canvaskit/chromium/canvaskit.wasm": "f504de372e31c8031018a9ec0a9ef5f0",
"canvaskit/chromium/canvaskit.js.symbols": "b61b5f4673c9698029fa0a746a9ad581",
".well-known/assetlinks.json": "9a149f0cb9451f543fccff1e85b8b246",
"flutter_bootstrap.js": "0a2aff9e47fc1d1adad8f3a70c3d3f4c",
"splash/img/light-3x.png": "16d6e10786f2823d0fce00808684ff60",
"splash/img/dark-4x.png": "bd3f04a558a7e865a8204ab7658aa0f8",
"splash/img/light-1x.png": "deaece8cd5d75868c332ad7fce0cd39b",
"splash/img/dark-1x.png": "deaece8cd5d75868c332ad7fce0cd39b",
"splash/img/light-2x.png": "4424c0a491eb0d85e6278bb721706155",
"splash/img/dark-2x.png": "4424c0a491eb0d85e6278bb721706155",
"splash/img/dark-3x.png": "16d6e10786f2823d0fce00808684ff60",
"splash/img/light-4x.png": "bd3f04a558a7e865a8204ab7658aa0f8",
"favicon.png": "0edcf9b037910956712c5221731e7895",
"index.html": "9ea517897714a21d94ca3eabae82442e",
"/": "9ea517897714a21d94ca3eabae82442e",
"flutter.js": "83d881c1dbb6d6bcd6b42e274605b69c"};
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
