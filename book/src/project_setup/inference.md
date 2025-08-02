# LLM intergration on iOS

## First steps and hard choice

<p>First things first, when it comes to building an iOS app with integrated LLM is the way iOS uses it. Actually, there are some ways to build and run LLM on iOS:</p>

<ul>
    <li>Use coremltools from pip</li>
    <li>Use .gguf with inference</li>
    <li>Use Media PipeLine from Google</li>
    <li>Use ONNX</li>
</ul>

<p>When going through each step we can find pros/cons of each:</p>

<table>
  <tr>
    <th></th>
    <th>coremltools</th>
    <th>.gguf</th>
    <th>Media Pipeline</th>
    <th>ONNX</th>
  </tr>
  <tr>
    <td>Pros</td>
    <td>LLM can further be integrated into an iOS app via CoreML</td>
    <td>The developer can gain more broader access for LLM settings</td>
    <td>Standrad way of integrating Google's LLMs into iOS/Android apps</td>
    <td>LLM can further be easily converted via coremltools</td>
  </tr>
  <tr>
    <td>Cons</td>
    <td>Not supported for now [08/01/2025]</td>
    <td>Too hard war for noobs</td>
    <td>Google Gemma 3n is not supported for now [08/01/2025]</td>
    <td>Need for high-performed Mac 16+ of RAM and Apple Silicon Pro+ processors</td>
  </tr>
</table>

<p>As we can see, there are very serious pros\cons for each way of integrating LLMs. Frankly speaking, we decided to use .gguf due to only one easy take: it is the only avaible way for integrating Google Gemma 3n in our case. We didn't have the best Mac on the market, couldn't use ONNX or Media PipeLine, so the only thing we could do is to convert Google Gemma 3n into .gguf and further use inference.</p>

<p>When we chose the way we integrate LLM into an iOS app, we needed to find the inference for that. After some time of surfing the Internet, we come across <a href="https://github.com/ggml-org/llama.cpp">llama.cpp inference</a>, which was the best way to integrate ANY LLM into Android, iOS, or any other platform. In our case that was an iOS SwiftUI project.</p>

## Inference setup

<p>I could write a really cool story on how I integrated Google Gemma 3n into iOS using <a href="https://github.com/ggml-org/llama.cpp">llama.cpp inference</a>, but I'd rather just provide an instruction on how do that.</p>

<p>We can easily divide the process into 3 steps:</p>
<ol>
    <li>Build Xcode framework for further use of llama package in Xcode</li>
    <li>Change some settings of LibLlama controller in SwiftUI app example, provided by the developers of llama.cpp</li>
    <li>Added everything we need into our own SwiftUI iOS app</li>
</ol>

<p>let me go over each step with explanation.</p>

### Building Xcode framework

<p>First things first, we need to clone llama.cpp repo on our Mac:</p>

```bash
$ git clone --recursive https://github.com/ggml-org/llama.cpp.git
```

<p>And go to the <b>examples/llama.swiftui</b> subdirectory, where we can find the little instruction on how to build llama.cpp for further use in iOS. It's just a simple command that runs in a root directory of llama.cpp:</p>

```bash
$ ./build-xcframework.sh
```

<p>And that's it! We did everything we need to use LLMs in iOS apps! That was so easy... Yeah, it is now. But back then, that was too hard, especially working with LibLlama settings. After building framework, I highly recommend to go to <b>LibLlama</b> controller (which can be found at <b>examples/llama.swiftui</b>) and add these lines of code in clear() method:</p>

```swift
func clear() {
    tokens_list.removeAll()
    temporary_invalid_cchars.removeAll()
    llama_memory_clear(llama_get_memory(context), true)

    self.n_cur = 0 // <- set n_cur to 0
    self.is_done = false // <- set is_done to false
}
```

<p>Why this is necessary for us? Well, let me clarify on how our model (Google Gemma 3n) will work: wen we start a conversation, we "write" our prompts and reponses into cache. But after those responses we don't clear that cache. Hence, our model thinks that we are still talking, but we are not. It doesn't even stop. For that we set these variables as demonstrated above.</p>
