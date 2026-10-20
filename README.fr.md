Construisons un chatbot propulsé par l'IA qui t'aide à apprendre une nouvelle langue 🗺️

Voici les **actions utilisateur** que nous allons construire dans cet exercice :
- En tant qu'utilisateur, je peux envoyer mon message et recevoir une réponse d'un tuteur IA
- En tant qu'utilisateur, je peux lister mes messages avec le tuteur

Dans le prochain exercice, [AI Language Tutor (Part 2)](../02-AI-Language-Tutor-Part-2), on ajoutera d'autres fonctionnalités :
- En tant qu'utilisateur, je peux lister toutes les langues que je suis en train d'apprendre
- En tant qu'utilisateur, je peux ajouter une nouvelle langue à apprendre
- En tant qu'utilisateur, je peux supprimer une langue
- En tant qu'utilisateur, je peux choisir une langue et l'apprendre (discuter avec le tuteur à propos de cette langue)
- En tant qu'utilisateur, mes conversations sont sauvegardées pour que je puisse reprendre là où je m'étais arrêté

Pour cet exercice, on va seulement utiliser **une langue codée en dur** (à toi de choisir laquelle). Dans le prochain exercice, on ajoutera la possibilité d'apprendre plusieurs langues. Mais pour l'instant, choisis une langue que tu as toujours voulu apprendre, et on construira l'application autour de ça. Pour l'exemple ici, on utilisera l'espagnol 🇪🇸

Le premier composant de notre logiciel est donc :
- **Messages**

## Comment on va construire ça

On va travailler en deux phases :

1. **La couche de données d'abord** : construis le modèle et le repository et utilise `rake` pour vérifier que ça fonctionne.
2. **Les fonctionnalités ensuite** : Une fois la couche de données solide, lance l'application et construis chaque fonctionnalité (controller + view) de bout en bout. Teste chacune d'elles en utilisant réellement l'application (`ruby app.rb`).

Même si les tests `rake` sont très utiles pour vérifier que la couche de données fonctionne, ils ne testent pas l'expérience utilisateur. On veut donc s'assurer de tester chaque fonctionnalité en utilisant réellement l'application et en la voyant fonctionner dans le terminal. Tu devrais lancer `ruby app.rb` au moins aussi souvent que tu utilises `rake`, sinon plus.

Cet exercice est aussi la première fois qu'on parle à un vrai modèle d'IA externe, donc avant d'écrire du code, on doit configurer ça.

## Configuration

On va utiliser la gem [`ruby_llm`](https://github.com/crmne/ruby_llm) pour parler à un modèle d'IA, et [`dotenv`](https://github.com/bkeepers/dotenv) pour garder notre clé API hors de notre code.

1. Installe les deux gems (si ce n'est pas déjà fait) en lançant cette commande dans ton terminal :
   ```bash
   gem install ruby_llm:1.2.0 dotenv
   ```

2. Crée un fichier `.env` à la racine de cet exercice avec ta clé API OpenAI :
   ```bash
   touch .env
   ```

   ```
   # .env
   OPENAI_API_KEY=sk-...
   ```
   ⚠️ **Ne commit jamais ta clé API sur GitHub !** Le `.gitignore` de cet exercice exclut déjà `.env`, mais vérifie toujours que le `.env` n'apparaît _pas_ dans ton `git status` avant de commit.

3. Regarde `config.rb`. Il est déjà rempli pour toi. Il charge ton fichier `.env` et configure `ruby_llm` avec ta clé API.
   Tu peux utiliser [ce guide](https://kitt.lewagon.com/notion/students/1f78924af01480d7a4a8f6df8150c221) pour obtenir une clé API gratuite. Ou tu peux t'inscrire sur OpenAI et obtenir une clé payante si tu veux utiliser l'IA au-delà de la limite gratuite.

4. Teste que ta clé fonctionne, directement depuis `irb` :
   ```ruby
   require "ruby_llm"
   RubyLLM.configure { |config| config.openai_api_key = "PASTE_YOUR_API_KEY_HERE" }
   chat = RubyLLM.chat
   puts chat.ask("Say hello!").content
   ```
   Tu devrais voir une réponse du modèle d'IA. Si ce n'est pas le cas, ouvre un ticket auprès de l'équipe pédagogique pour avoir de l'aide.

## Messages

### Modèle Message

Commençons par la couche de données pour les messages.

Chaque `message` a :
- un `id` (note : celui-ci doit être optionnel, car il sera assigné par le repository plus tard)
- un `role` : `"user"` (l'humain) ou `"assistant"` (le tuteur IA)
- un `content` : le texte réel du message

Écris du code pour implémenter ceci et crash-test ton modèle. Puis teste ton code en lançant `rake message`.

Tout est vert ? Bien ! C'est le moment de faire `git add`, `commit` et `push`.

### Repository Message

Maintenant qu'on a un modèle représentant nos messages, on a besoin d'un repository pour les stocker.

Pour l'instant, ce repository est seulement **en mémoire**—mais il doit quand même être initialisé avec un chemin vers un fichier CSV (une `String`), même s'il ne va rien lire ni écrire dedans pour l'instant. On va ajouter les fonctionnalités CSV plus tard. Le comportement qu'on veut pour le repository est de :
- `create` un nouveau message et lui assigner un `id` unique
- Récupérer `all` les messages

Écris du code pour implémenter ceci et crash-test ton repository dans `irb`. Puis teste ton code en lançant `rake message`.

Tout est vert ? Bien ! C'est le moment de faire `git add`, `commit` et `push`.

### MessageRouter et app

Maintenant, commençons à construire les vraies fonctionnalités de notre application. Avant de pouvoir implémenter les fonctionnalités des messages, on doit pouvoir réellement lancer notre application.

Pour faire ça, on a besoin d'un router et on doit remplir le fichier `app.rb`. On va appeler ce router `MessageRouter` (pas juste `Router` comme on l'a fait avant) — tu verras pourquoi dans le prochain exercice, quand on construira un second router différent.

Le router est responsable d'afficher les différentes fonctionnalités que l'utilisateur peut sélectionner et de router le choix de l'utilisateur vers l'action correspondante du controller. Le fichier `app.rb` est responsable de require tous les fichiers nécessaires, d'instancier un router et d'exécuter sa méthode `run` pour lancer l'application.

Crée `app/routers/message_router.rb` et remplis `app.rb` pour implémenter ça. Si tu es bloqué, tu peux retourner voir [Food Delivery](https://kitt.lewagon.com/camps/<user.batch_slug>/challenges?path=02-OOP%2F04-Food-Delivery%2F01-Food-Delivery) et télécharger la solution pour t'en inspirer. **Pas besoin d'instancier le router avec un controller** puisqu'on ne l'a pas encore. Affiche juste `TODO` pour le moment quand l'utilisateur sélectionne une tâche.

Il n'y a pas de rake pour cette partie. Lance ton application en exécutant cette commande dans le terminal :

```bash
ruby app.rb
```

Tout fonctionne ? Bien ! C'est le moment de faire `git add`, `commit` et `push`.

### Fonctionnalités des messages

Passons à la création de notre `MessagesController`. Voici les **actions utilisateur** qu'on veut implémenter :
- `add` un nouveau message
- `list` tous les messages

⚠️ Évite de construire les deux fonctionnalités en même temps. **Code en silo**, en construisant d'abord entièrement la fonctionnalité `add` et en la testant dans le terminal en lançant ton application avec `ruby app.rb`. Puis passe à la fonctionnalité `list` et fais la même chose.

Ton `MessagesController` doit être initialisé avec **un** argument : une instance de `MessageRepository`. Dans `#initialize`, construis ta propre session de chat avec `RubyLLM.chat.with_instructions(...)`, en lui passant un system prompt — code juste en dur ta langue choisie directement dans le texte de ce prompt pour l'instant, par exemple _"You are a friendly Spanish tutor..."_. Un bon pattern serait d'avoir une méthode `private` sur le controller appelée `#system_prompt` qui retourne cette chaîne, pour pouvoir facilement la changer plus tard.

Tu vas aussi avoir besoin de créer une `MessagesView` pour afficher et demander les informations pertinentes à l'utilisateur.

L'action `add` est la partie de cet exercice où tu vas devoir interagir avec le LLM 🎉 Ton but n'est pas seulement de sauvegarder le message de l'utilisateur, mais aussi d'obtenir une réponse du tuteur IA et de la sauvegarder aussi. Donc, à chaque fois que `#add` est appelée, deux messages sont en fait créés, un du `user` et l'autre de l'`assistant`. Tu dois aussi utiliser la view pour afficher la réponse du tuteur à l'utilisateur pour qu'il puisse la voir dans le terminal.

Pour tester ton controller, connecte-le à ton application en l'instanciant dans `app.rb` et en le passant à ton `MessageRouter`. Puis tu peux crash-tester ton code en lançant ton application :

```bash
ruby app.rb
```

`rake` devrait aussi t'aider à passer en revue toutes ces étapes. 📝 **Note :** nos specs n'appellent jamais la vraie API — elles simulent la réponse de l'IA, donc `rake` ne te coûte jamais rien.

📝 **Note :** Il n'y a pas de `rake` spécifique pour les views dans cet exercice (contrairement aux modèles et controllers). N'hésite pas à être un peu créatif 🎨 sur ce que tes views doivent afficher, mais assure-toi qu'elles fonctionnent correctement en lançant `ruby app.rb`.

Si tout fonctionne, voici à quoi ton application devrait ressembler :

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

Tout est vert et fonctionne ? Bien ! C'est le moment de faire `git add`, `commit` et `push`.

***

Bravo, tu as terminé cet exercice ! 🎉 C'est une belle réussite. Rends-toi sur [AI Language Tutor (Part 2)](../02-AI-Language-Tutor-Part-2) pour ajouter le support multi-langues, sauvegarder ta progression, et (en option) ajouter une connexion. C'est un peu plus complexe, donc ne t'inquiète pas si tu ne le termines pas aujourd'hui.
