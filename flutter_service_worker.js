'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"flutter.js": "24bc71911b75b5f8135c949e27a2984e",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"manifest.json": "91bd4ddc246d258d44eec6f6b4138ee8",
"index.html": "5fc3e028e6602aeff87da441c7d65d82",
"/": "5fc3e028e6602aeff87da441c7d65d82",
"assets/shaders/stretch_effect.frag": "40d68efbbf360632f614c731219e95f0",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/AssetManifest.bin.json": "7c9b202ccbbb982a3f0114c37650a415",
"assets/assets/images/background2.png": "ab713c96125a60ec72563ae5df84eff3",
"assets/assets/images/background.png": "98686a8a9eb43d77dcca68186954f48b",
"assets/assets/images/utamabutton.png": "11e7d845c3b4ea17069a1b2c1c75b93a",
"assets/assets/images/tree1.png": "4cd35ed04cec5fab0c014a1828cc587d",
"assets/assets/images/forest1.png": "01da14180a4c1f7de3821b50ed33a01c",
"assets/assets/images/rimbarun.png": "ae380f228bd5ff687d375e00412ed777",
"assets/assets/images/mipmap1.png": "c40128d30d62680444089e58ede61ce6",
"assets/assets/images/notabutton.png": "cf624136d5fcbe4e981d1b75b8f9111a",
"assets/assets/images/harimau1.png": "08b858594fa67bdd830c64415af1a98d",
"assets/assets/images/playbutton.png": "d5157b6646d3b6fb018dce11b8a5932d",
"assets/assets/images/map.png": "1e2c9dd65bc4e663d501c651d0a8cda5",
"assets/assets/images/background2a.png": "4b1bf66861016ead8c96c50b0d34e35b",
"assets/assets/images/scene1a.png": "c2b9d932e5635cf38365ecd3210be835",
"assets/assets/images/mipmap.png": "811e36f43c0080c4db9c8469d47fbabe",
"assets/assets/images/sky1.png": "28de6870c651305df3872cb37ab21570",
"assets/assets/images/over.png": "92061d415de54d60410500b2bc0cb364",
"assets/assets/images/lari2.png": "be16b5633830d096b2e1c8f229f07b16",
"assets/assets/images/scene1b.png": "8224c255498b3563827ac0953a76a7c0",
"assets/assets/images/lari1.png": "1abdc32e343983ea449117f0953df8f0",
"assets/assets/images/bush1.png": "4cb4da8d0d211b70f6e4841b6af77c17",
"assets/assets/images/mipmap2.png": "b422c839aec58cd768af7b163a17b697",
"assets/assets/images/hi.png": "1a8dc172380cd6f8cd2a43def2364bd9",
"assets/assets/images/next.png": "5d5037605043d0da3de5e658492ffac6",
"assets/assets/images/scene1c.png": "f115621ed2df0c09cd30a21ac4f6e70e",
"assets/assets/images/good.png": "2c20fbea166108bbdf3081cc11a1a994",
"assets/assets/images/dialog.png": "3110ce56c083de214522f18b45c75c81",
"assets/assets/images/victory.png": "9afe3594a14c2c5bcaaecff6bd8284d8",
"assets/assets/images/manualbutton.png": "3a16a75da373ccda2c4929c6097801f1",
"assets/assets/images/harimau3.png": "cc2fde4d7a52003575ecfa2417598712",
"assets/assets/images/scene1.png": "252753b8e665f8fe750b5a5de6da1f98",
"assets/assets/images/settingbutton.png": "24e4bf8c3aa07122129d8c949fe9b363",
"assets/assets/images/harimau2.png": "30dfac382f985f63c36895810614b3c8",
"assets/assets/images/lari3.png": "71a250b1fbba81db1f357ba74e3f36a3",
"assets/assets/images/settings.png": "67115acb2b91e002547415ba7e77d35a",
"assets/assets/images/background3.png": "4f62a6929ae9ebd5a187afcd48723ea5",
"assets/assets/images/soalan.png": "683d340a6216a3afc1caa5e267290e08",
"assets/assets/images/dialog2.png": "5ce76d0e0b91746aac2ec2db8eda9aa1",
"assets/fonts/MaterialIcons-Regular.otf": "c0ad29d56cfe3890223c02da3c6e0448",
"assets/NOTICES": "9a4a8acb90a9cef285d549dace6a6968",
"assets/FontManifest.json": "7b2a36307916a9721811788013e65289",
"assets/AssetManifest.bin": "a704aad3a808d74cf209f7d6fc9b28b0",
"canvaskit/chromium/canvaskit.wasm": "a726e3f75a84fcdf495a15817c63a35d",
"canvaskit/chromium/canvaskit.js": "a80c765aaa8af8645c9fb1aae53f9abf",
"canvaskit/chromium/canvaskit.js.symbols": "e2d09f0e434bc118bf67dae526737d07",
"canvaskit/skwasm_heavy.wasm": "b0be7910760d205ea4e011458df6ee01",
"canvaskit/skwasm_heavy.js.symbols": "0755b4fb399918388d71b59ad390b055",
"canvaskit/skwasm.js": "8060d46e9a4901ca9991edd3a26be4f0",
"canvaskit/canvaskit.wasm": "9b6a7830bf26959b200594729d73538e",
"canvaskit/skwasm_heavy.js": "740d43a6b8240ef9e23eed8c48840da4",
"canvaskit/canvaskit.js": "8331fe38e66b3a898c4f37648aaf7ee2",
"canvaskit/skwasm.wasm": "7e5f3afdd3b0747a1fd4517cea239898",
"canvaskit/canvaskit.js.symbols": "a3c9f77715b642d0437d9c275caba91e",
"canvaskit/skwasm.js.symbols": "3a4aadf4e8141f284bd524976b1d6bdc",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"flutter_bootstrap.js": "8dbecbe758767f39d86da5479dde1aa2",
"version.json": "f75168c6f0fb6a919cf169d9bcf8a632",
"main.dart.js": "850e869218cf0be3f3cd0913f8b2fbc1"};
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
