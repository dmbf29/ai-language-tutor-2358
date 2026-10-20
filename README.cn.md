让我们构建一个由 AI 驱动的聊天机器人，帮助你学习一门新语言 🗺️

以下是我们将在本练习中构建的**用户操作**：
- 作为用户，我可以发送消息并获得 AI 导师的回复
- 作为用户，我可以列出我和导师的消息记录

在下一个练习 [AI Language Tutor (Part 2)](../02-AI-Language-Tutor-Part-2) 中，我们会添加更多功能：
- 作为用户，我可以列出我正在学习的所有语言
- 作为用户，我可以添加一门新的语言来学习
- 作为用户，我可以删除一门语言
- 作为用户，我可以选择一门语言并学习它（就该语言与导师聊天）
- 作为用户，我的对话会被保存，这样我可以从上次停下的地方继续

在本练习中，我们只会使用**一种写死的语言**（你来选择是哪种）。在下一个练习中，我们会添加学习多种语言的能力。但现在，选一门你一直想学的语言，我们就围绕它来构建应用程序。这里的示例我们将使用西班牙语 🇪🇸

所以，我们软件的第一个组件是：
- **Messages**

## 我们将如何构建它

我们将分两个阶段进行：

1. **先做数据层**：构建模型和 repository，并用 `rake` 验证它是否正常工作。
2. **再做功能**：数据层稳固之后，让应用程序运行起来，端到端地构建每个功能（controller + view）。通过实际使用应用程序（`ruby app.rb`）来测试每一个功能。

虽然 `rake` 测试对于检查数据层是否正常工作非常有用，但它们并不测试用户体验。所以我们要确保通过实际使用应用程序、在终端里看到它运行，来测试每个功能。你运行 `ruby app.rb` 的次数应该不少于甚至多于使用 `rake` 的次数。

这个练习也是我们第一次与真实的外部 AI 模型对话，所以在写任何代码之前，我们需要先做好相关配置。

## 配置

我们将使用 [`ruby_llm`](https://github.com/crmne/ruby_llm) gem 与 AI 模型对话，并使用 [`dotenv`](https://github.com/bkeepers/dotenv) 将我们的 API 密钥保存在代码之外。

1. 安装这两个 gem（如果你还没装的话），在终端运行这个命令：
   ```bash
   gem install ruby_llm:1.2.0 dotenv
   ```

2. 在本练习的根目录下创建一个 `.env` 文件，写入你的 OpenAI API 密钥：
   ```bash
   touch .env
   ```

   ```
   # .env
   OPENAI_API_KEY=sk-...
   ```
   ⚠️ **永远不要把你的 API 密钥提交到 GitHub！** 本练习的 `.gitignore` 已经排除了 `.env`，但在提交之前，请始终仔细检查 `.env` 是否*没有*出现在你的 `git status` 中。

3. 看一下 `config.rb`。它已经帮你写好了。它会加载你的 `.env` 文件，并用你的 API 密钥配置 `ruby_llm`。
   你可以使用[这个指南](https://kitt.lewagon.com/notion/students/1f78924af01480d7a4a8f6df8150c221)获取一个免费的 API 密钥。或者，如果你想使用超出免费额度的 AI，也可以注册 OpenAI 并获取付费密钥。

4. 直接在 `irb` 中测试你的密钥是否有效：
   ```ruby
   require "ruby_llm"
   RubyLLM.configure { |config| config.openai_api_key = "PASTE_YOUR_API_KEY_HERE" }
   chat = RubyLLM.chat
   puts chat.ask("Say hello!").content
   ```
   你应该会看到 AI 模型的回复。如果没有，请向教学团队开一张 ticket 寻求帮助。

## Messages

### Message 模型

让我们从消息的数据层开始。

每个 `message` 都有：
- 一个 `id`（注意：这个应该是可选的，因为它稍后会由 repository 分配）
- 一个 `role`：`"user"`（人类）或 `"assistant"`（AI 导师）
- 一个 `content`：消息的实际文本内容

写一些代码来实现这个，并对你的模型进行 crash-test。然后运行 `rake message` 测试你的代码。

全部通过了吗？很好！是时候 `git add`、`commit` 并 `push` 了。

### Message repository

现在我们有了一个代表消息的模型，我们需要一个 repository 来存储它们。

目前，这个 repository 只是**内存中**的——但它仍然应该用一个 CSV 文件路径（一个 `String`）来初始化，即使它现在还不会读写任何东西。我们稍后会添加 CSV 功能。我们希望这个 repository 具备以下行为：
- `create` 一条新消息并为它分配一个唯一的 `id`
- 获取 `all` 消息

写一些代码来实现这个，并在 `irb` 中对你的 repository 进行 crash-test。然后运行 `rake message` 测试你的代码。

全部通过了吗？很好！是时候 `git add`、`commit` 并 `push` 了。

### MessageRouter 和 app

现在，让我们开始构建应用程序真正的功能。在实现消息功能之前，我们需要能够真正启动我们的应用程序。

要做到这一点，我们需要一个 router，并且需要填写 `app.rb` 文件。我们把这个 router 叫做 `MessageRouter`（而不是像之前那样只叫 `Router`）—— 你会在下一个练习中明白为什么，那时我们会构建第二个不同的 router。

router 负责显示用户可以选择的不同功能，并将用户的选择路由到对应 controller 的相应 action。`app.rb` 文件负责 require 所有必要的文件、实例化一个 router，并执行它的 `run` 方法来启动应用程序。

创建 `app/routers/message_router.rb` 并填写 `app.rb` 来实现这个。如果你卡住了，可以回到 [Food Delivery](https://kitt.lewagon.com/camps/<user.batch_slug>/challenges?path=02-OOP%2F04-Food-Delivery%2F01-Food-Delivery) 下载解答获取一些灵感。**不需要用 controller 来实例化 router**，因为我们还没有它。当用户选择一个任务时，暂时只打印 `TODO` 就行了。

这部分没有 rake。在终端运行这个命令来启动你的应用程序：

```bash
ruby app.rb
```

一切正常了吗？很好！是时候 `git add`、`commit` 并 `push` 了。

### Messages 功能

让我们继续创建 `MessagesController`。以下是我们想要实现的**用户操作**：
- `add` 一条新消息
- `list` 所有消息

⚠️ 你不应该同时尝试构建这两个功能。**孤立地编码（code in silo）**，先完整地构建 `add` 功能，并通过 `ruby app.rb` 启动应用程序在终端中测试它。然后再转向 `list` 功能，做同样的事情。

你的 `MessagesController` 应该用**一个**参数初始化：一个 `MessageRepository` 实例。在 `#initialize` 内部，用 `RubyLLM.chat.with_instructions(...)` 构建你自己的聊天会话，给它传入一个 system prompt —— 现在先把你选择的语言直接写死在这个 prompt 的文本里，例如 _"You are a friendly Spanish tutor..."_。一个好的做法是在 controller 上写一个 `private` 方法 `#system_prompt`，返回这个字符串，方便你以后修改。

你还需要创建一个 `MessagesView`，用来向用户展示信息、并询问相关信息。

`add` 这个 action 是本练习中你需要与 LLM 交互的部分 🎉 你的目标不仅仅是保存用户的消息，还要获取 AI 导师的回复并保存它。所以，每次调用 `#add`，实际上都会创建两条消息，一条来自 `user`，另一条来自 `assistant`。你还应该用 view 把导师的回复展示给用户，让他们能在终端里看到。

要测试你的 controller，在 `app.rb` 中实例化它并把它传给你的 `MessageRouter`，把它和你的应用程序连接起来。然后你可以通过启动应用程序来 crash-test 你的代码：

```bash
ruby app.rb
```

`rake` 也应该能帮你走完这些步骤。📝 **注意：** 我们的 spec 从不调用真实的 API —— 它们会伪造 AI 的回复，所以 `rake` 永远不会花你的钱。

📝 **注意：** 本练习中没有针对 view 的专门 rake（不像 model 和 controller 那样）。可以稍微发挥一点艺术性 🎨 来想想你的 view 应该展示什么，但要确保通过运行 `ruby app.rb` 来验证它们工作正常。

如果一切正常，你的应用程序应该是这样的：

```
--------------------
------- MENU -------
--------------------
1. List my conversation
2. Send a message
3. Stop and exit
> 2

Your message?
> How do you say cat?

Tutor: Gato (cat)

--------------------
------- MENU -------
--------------------
1. List my conversation
2. Send a message
3. Stop and exit
> 1

You: How do you say cat?
Tutor: Gato (cat)
```

全部通过并且正常工作了吗？很好！是时候 `git add`、`commit` 并 `push` 了。

***

做得好，你已经完成了这个练习！🎉 这是一个了不起的成就。前往 [AI Language Tutor (Part 2)](../02-AI-Language-Tutor-Part-2)，去添加多语言支持、保存你的进度，并且（可选地）添加登录功能。它会更复杂一些，所以如果你今天没能完成也不用担心。
