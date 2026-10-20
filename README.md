Let's build an AI-powered chatbot that helps you learn a new language 🗺️

Here are the **user actions** we'll build in this challenge:
- As a user, I can send my message and get a response from an AI tutor
- As a user, I can list my messages with the tutor

In the next challenge, [AI Language Tutor (Part 2)](../02-AI-Language-Tutor-Part-2), we'll add more features:
- As a user, I can list all the languages I'm tracking
- As a user, I can add a new language to learn
- As a user, I can delete a language
- As a user, I can pick a language and learn it (chat with the tutor about that language)
- As a user, my conversations are saved so I can pick up where I left off

For this challenge, we'll only use **one hardcoded language** (you pick which one). In the next challenge, we'll add the ability to learn multiple languages. But for now, you can pick a language you've always wanted to learn, and we'll build the app around that. For the sample here, we'll use Spanish 🇪🇸

So, the first component of our software is:
- **Messages**

## How we'll build this

We'll work in two phases:

1. **Data layer first**: build the model and repository and use `rake` to verify it works.
2. **Features second**: Once the data layer is solid, get the app running and build each feature (controller + view) end-to-end. Test each one by actually using the app (`ruby app.rb`).

Though the `rake` tests are very useful to check that the data layer works, they don't test the user experience. So we want to make sure to test each feature by actually using the app and seeing it work in the terminal. You should be running `ruby app.rb` as much if not more than you use `rake`.

This challenge is also our first time talking to a real, external AI model, so before writing any code, we need to set that up.

## Setup

We'll use the [`ruby_llm`](https://github.com/crmne/ruby_llm) gem to talk to an AI model, and [`dotenv`](https://github.com/bkeepers/dotenv) to keep our API key out of our code.

1. Install both gems (if you haven't already) by running this command in your terminal:
   ```bash
   gem install ruby_llm:1.2.0 dotenv
   ```

2. Create a `.env` file at the root of this challenge:
   ```bash
   touch .env
   ```

   You will need an API key to talk to the AI model:

   Keys are **Paid, via OpenAI**. Sign up on [OpenAI](https://platform.openai.com/account/api-keys) and generate an API key, then add it to your `.env`:
     ```
     # .env
     OPENAI_API_KEY=sk-...
     ```
   ⚠️ **Never commit your API key to GitHub!** This challenge's `.gitignore` already excludes `.env`, but always double check that the `.env` does _not_ show up in your `git status` before committing. This key is as sensitive as a password, and if it leaks, someone else could use it and rack up charges on your account. So, please be careful with it.

3. Take a look at `config.rb`. It's already filled in for you and handles both options above — it loads your `.env` file and configures `ruby_llm` with whichever key you provided.

4. Test that your key works, straight from `irb` (run from the root of this challenge, so it can find `config.rb`):
   ```ruby
   require_relative "config"
   chat = RubyLLM.chat
   puts chat.ask("Say hello!").content
   ```
   You should see a response from the AI model. If you don't, open a ticket with your teaching staff for help.

## Messages

### Message model

Let's start with the data layer for messages.

Each `message` has:
- an `id` (Note: This should be optional because the repository will assign it later)
- a `role`: `"user"` (the human) or `"assistant"` (the AI tutor)
- a `content`: the actual text of the message

Write some code to implement this and crash-test your model. Then test your code by running `rake message`.

All green? Good! Time to `git add`, `commit` and `push`.

### Message repository

Now that we have a model representing our messages, we need a repository to store them.

For now, this repository is only **in-memory**—but it should still be initialized with a CSV file path (a `String`), even though it won't read or write anything to it yet. We're going to add CSV features later. The behavior we want for the repository is to:
- `create` a new message and assign it a unique `id`
- Get `all` the messages

Write some code to implement this and crash-test your repository in `irb`. Then test your code by running `rake message`.

All green? Good! Time to `git add`, `commit` and `push`.

### MessageRouter and app

Now, let's start building the actual features of our app. Before we can implement the messages features, we need to be able to actually launch our app.

To do this, we need a router and we need to fill in the `app.rb` file. We'll call this router `MessageRouter` (not just `Router` like we've done before) — you'll see why in the next challenge, when we build a second, different router.

The router is responsible for displaying the different features the user can select and routing the user's choice to the corresponding action of the matching controller. The `app.rb` file is responsible for requiring all the necessary files, instantiating a router and executing its `run` method to launch the app.

Create `app/routers/message_router.rb` and fill in `app.rb` to implement this. If you're stuck, you can go back to [Food Delivery](https://kitt.lewagon.com/camps/<user.batch_slug>/challenges?path=02-OOP%2F04-Food-Delivery%2F01-Food-Delivery) and download the solution to get some inspiration. **No need to instantiate the router with a controller** as we don't have it yet. Just print `TODO` for the moment when the user selects a task.

There is no rake for this part. Launch your app by running this command in the terminal:

```bash
ruby app.rb
```

Everything is working? Good! Time to `git add`, `commit` and `push`.

### Messages features

Let's move to making our `MessagesController`. Here are the **user actions** we want to implement:
- `add` a new message
- `list` all messages

⚠️ You don't want to try building both features at the same time. **Code in silo**, first building the entire `add` feature and testing it in the Terminal by launching your app with `ruby app.rb`. Then move to the `list` feature and do the same.

Your `MessagesController` should be initialized with **one** argument: a `MessageRepository` instance. Inside `#initialize`, build your own chat session with `RubyLLM.chat.with_instructions(...)`, passing it a system prompt — just hardcode your chosen language directly into that prompt's text for now, e.g. _"You are a friendly Spanish tutor..."_. A good pattern would be to include a `private` method on the controller called `#system_prompt` that returns the string, so you can easily change it later.

You'll also need to create a `MessagesView` to display and ask for the relevant information to the user.

The `add` action is the part of this challenge where you'll need to interact with the LLM 🎉 Your goal is not just to save the user's message, but also to get a response from the AI tutor and save that too. So, each time `#add` gets called, two messages are actually created, one from the `user` and the other from the `assistant`. You should also use the view to display the tutor's response to the user so they can see it in the terminal.

To test your controller, link it to your app by instantiating it in `app.rb` and passing it to your `MessageRouter`. Then you can crash-test your code by launching your app:

```bash
ruby app.rb
```

`rake` should also help you go through all these steps. 📝 **Note:** our specs never call the real API — they fake the AI's response, so `rake` never costs you anything.

📝 **Note:** There is no specific `rake` for the views in this challenge (unlike the models and controllers). Feel free to think a bit artistically 🎨 about what your views should show, but make sure they work properly by running `ruby app.rb`.

If everything is working, here's what your app should look like:

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

All green and working? Good! Time to `git add`, `commit` and `push`.

***

Nice work, you've completed this challenge! 🎉 This is a big accomplishment. Head over to [AI Language Tutor (Part 2)](../02-AI-Language-Tutor-Part-2) to add multi-language support, save your progress, and (optionally) sign in. It's a bit more complex, so please don't worry if you aren't able to finish it today.
