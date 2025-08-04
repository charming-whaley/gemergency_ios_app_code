# App publishing

<p>We needed to publish the Gemergency app — not on the App Store yet, but on TestFlight. The goal was straightforward: while it's obvious the app runs fine in the Xcode simulator, we had to verify that it also works properly on real devices.</p> 

<p>To publish the app on TestFlight, we followed these steps:</p>
<ol>
    <li>Create an Apple Developer account</li>
    <li>Change app scheme from <b>Debug</b> to <b>Release</b></li>
    <li>Send an app to App Store Connect</li>
    <li>Publish app on TestFlight using App Store Connect</li>
    <li>Download TestFlight app on iPhone</li>
</ol>
<p>While these steps may seem simple, they weren’t. We failed to run Gemergency on real devices five times. The issue came down to a single line of code in the <b>LibLlama</b>:</p>

```swift
static func create_context(path: String) throws -> LlamaContext {
    llama_backend_init()
    var model_params = llama_model_default_params() // <- add this line

#if targetEnvironment(simulator)
    model_params.n_gpu_layers = 0
    print("Running on simulator, force use n_gpu_layers = 0")
#endif
    model_params.n_gpu_layers = 0 // <- add this line

    let model = llama_model_load_from_file(path, model_params)
    guard let model else {
        print("Could not load model at \(path)")
        throw LlamaError.couldNotInitializeContext
    }

    let n_threads = max(1, min(8, ProcessInfo.processInfo.processorCount - 2))
    print("Using \(n_threads) threads")

    var ctx_params = llama_context_default_params()
    ctx_params.n_ctx = 2048
    ctx_params.n_threads       = Int32(n_threads)
    ctx_params.n_threads_batch = Int32(n_threads)

    let context = llama_init_from_model(model, ctx_params)
    guard let context else {
        print("Could not load context!")
        throw LlamaError.couldNotInitializeContext
    }

    return LlamaContext(model: model, context: context)
}
```

<p>Without that fix, the app simply wouldn’t work on physical devices. Once we resolved it, we successfully published the app on TestFlight.</p>