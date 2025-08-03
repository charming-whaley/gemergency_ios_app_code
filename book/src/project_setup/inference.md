# LLM intergration on iOS

## Integration choice

<p>In the beginning, when it comes to building an iOS app with LLM, the developer needs to choose the way it will be integrated in the app. In our case, there were standard ways of using that on-device:</p>

<ul>
    <li><a href="https://pypi.org/project/coremltools/">coremltools</a> from pip</li>
    <li><a href="https://github.com/ggml-org/llama.cpp">llama.cpp inference</a> with .gguf file extension</li>
    <li><a href="https://ai.google.dev/edge/mediapipe/solutions/guide">Google's MediaPipe</a></li>
    <li>Use of <a href="https://onnx.ai/">ONNX</a></li>
</ul>

<p>After some time of working with all these methods, we came across on pros/cons of each of those ways:</p>

<table>
  <tr>
    <th></th>
    <th>coremltools</th>
    <th>llama.cpp</th>
    <th>MediaPipe</th>
    <th>ONNX</th>
  </tr>
  <tr>
    <td>Pros</td>
    <td>Easily integrated via Apple's CoreML</td>
    <td>A developer can gain access to lower-level settings</td>
    <td>Standard way of integrating Google's LLMs</td>
    <td>Use with coremltools by running just one command</td>
  </tr>
  <tr>
    <td>Cons</td>
    <td>Not supported for now [08/03/2025]</td>
    <td>Too hard war for noobs</td>
    <td>Google Gemma 3n is not supported for now [08/03/2025]</td>
    <td>Need for high-performed Mac 16+ of RAM and Apple Silicon Pro+ processors</td>
  </tr>
</table>

<p>Unfortunately, we couldn't use <i>coremltools</i> or <i>ONNX</i>, which are considered as the best tools for using LLMs on iOS, so we narrowed such tools down to <i>llama.cpp</i> and <i>MediaPipe</i>. And, as it often happens, <i>MediaPipe</i> became not appropriate for us because we realized that there is no way to convert Google Gemma 3n into .task file extension. Hence, the only thing we could try is <i>llama.cpp</i></p>

<p>We are going through each LLM integration step in the Gemergency iOS app. We first start with <i>llama.cpp</i> setup and finally go to building our own SwiftUI iOS app</p>

## Inference setup

<p>I could write a really cool story on how I integrated Google Gemma 3n into iOS using <a href="https://github.com/ggml-org/llama.cpp">llama.cpp inference</a>, but I'd rather just provide an instruction on how do that.</p>

<p>We can easily divide the process into 3 steps:</p>
<ol>
    <li>Build Xcode framework for further use of llama package in Xcode</li>
    <li>Change some settings of LibLlama controller in SwiftUI app example, provided by the developers of llama.cpp</li>
    <li>Added everything we need into our own SwiftUI iOS app</li>
</ol>

<p>let me go over each step with explanation.</p>

### I. Building Xcode framework

<p>First things first, we need to clone llama.cpp repo on our Mac:</p>

```bash
$ git clone --recursive https://github.com/ggml-org/llama.cpp.git
```

<p>And go to the <b>examples/llama.swiftui</b> subdirectory, where we can find the little instruction on how to build llama.cpp for further use in iOS. It's just a simple command that runs in a root directory of llama.cpp:</p>

```bash
$ ./build-xcframework.sh
```

<p>And that's it! We did everything we need to use LLMs in iOS apps! That was so easy... Yeah, it is now. But back then, that was too hard, especially working with LibLlama settings.</p>  

### II. Changing LibLlama

<p>After building that framework, I highly recommend to go to <b>LibLlama</b> controller (which can be found at <b>examples/llama.swiftui</b>) and add these lines of code in clear() method:</p>

```swift
func clear() {
    tokens_list.removeAll()
    temporary_invalid_cchars.removeAll()
    llama_memory_clear(llama_get_memory(context), true)

    self.n_cur = 0 // <- set n_cur to 0
    self.is_done = false // <- set is_done to false
}
```

<p>Why this is necessary for us? Well, let me clarify on how our model (Google Gemma 3n) will work: </p>

<p>when we start a conversation, we "write" our prompts and reponses into cache. But after those responses we don't clear that cache. Hence, our model thinks that we are still talking, but we are not. It doesn't even stop. For that we set these variables as demonstrated above.</p>

<p>And we are done! Now we can start building iOS app with SwiftUI and integrated Google Gemma 3n!</p>
