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

