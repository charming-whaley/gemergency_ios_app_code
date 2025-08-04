# Gemergency app publishing

## Publishing process

<p>After developing our app, we wanted to make Gemergency easily accessible, so that anyone could download and use it on an iPhone/iPad. However, we quickly ran into two key challenges: where should we publish the app, and how could we get Gemma 3n running on actual devices? It might sound weird, but these were real problems</p>

<p>Let me explain why this matters and what solutions we found:</p>
<ul>
    <li>Where should we publish the app? - there were no time and opportunities to publish the app on the App Store. So had to find another platform where we could distribute Gemergency. There was only one such platform - TestFlight (it's not directly App Store, but the app might still be used by users)</li>
    <li>How could we make Gemma 3n running on physical devices? - since the first Gemergency beta, there was no opportunity to run Gemma 3n on physical device. We found very interesting solution that we are going to explain below though</li>
</ul>



## Important changes

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