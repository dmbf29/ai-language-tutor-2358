Vamos a construir un chatbot con IA que te ayude a aprender un nuevo idioma 🗺️

Aquí están las **acciones de usuario** que construiremos en este ejercicio:
- Como usuario, puedo enviar mi mensaje y recibir una respuesta de un tutor de IA
- Como usuario, puedo listar mis mensajes con el tutor

En el próximo ejercicio, [AI Language Tutor (Part 2)](../02-AI-Language-Tutor-Part-2), añadiremos más funcionalidades:
- Como usuario, puedo listar todos los idiomas que estoy siguiendo
- Como usuario, puedo agregar un nuevo idioma para aprender
- Como usuario, puedo eliminar un idioma
- Como usuario, puedo elegir un idioma y aprenderlo (chatear con el tutor sobre ese idioma)
- Como usuario, mis conversaciones se guardan para poder retomar donde lo dejé

Para este ejercicio, solo usaremos **un idioma fijo** (tú eliges cuál). En el próximo ejercicio, añadiremos la capacidad de aprender varios idiomas. Pero por ahora, elige un idioma que siempre hayas querido aprender, y construiremos la aplicación alrededor de eso. Para el ejemplo aquí, usaremos español 🇪🇸

Así que, el primer componente de nuestro software es:
- **Messages**

## Cómo vamos a construir esto

Vamos a trabajar en dos fases:

1. **La capa de datos primero**: construye el modelo y el repositorio y usa `rake` para verificar que funciona.
2. **Las funcionalidades después**: Una vez que la capa de datos esté sólida, pon en marcha la aplicación y construye cada funcionalidad (controller + view) de principio a fin. Prueba cada una usando realmente la aplicación (`ruby app.rb`).

Aunque los tests de `rake` son muy útiles para comprobar que la capa de datos funciona, no prueban la experiencia de usuario. Así que queremos asegurarnos de probar cada funcionalidad usando realmente la aplicación y viéndola funcionar en la terminal. Deberías ejecutar `ruby app.rb` tanto o más de lo que uses `rake`.

Este ejercicio también es la primera vez que hablamos con un modelo de IA real y externo, así que antes de escribir código, necesitamos configurar eso.

## Configuración

Vamos a usar la gem [`ruby_llm`](https://github.com/crmne/ruby_llm) para hablar con un modelo de IA, y [`dotenv`](https://github.com/bkeepers/dotenv) para mantener nuestra clave de API fuera de nuestro código.

1. Instala ambas gems (si todavía no lo has hecho) ejecutando este comando en tu terminal:
   ```bash
   gem install ruby_llm:1.2.0 dotenv
   ```

2. Crea un archivo `.env` en la raíz de este ejercicio con tu clave de API de OpenAI:
   ```bash
   touch .env
   ```

   ```
   # .env
   OPENAI_API_KEY=sk-...
   ```
   ⚠️ **¡Nunca subas tu clave de API a GitHub!** El `.gitignore` de este ejercicio ya excluye `.env`, pero siempre verifica que el `.env` _no_ aparezca en tu `git status` antes de hacer commit.

3. Échale un vistazo a `config.rb`. Ya está completado para ti. Carga tu archivo `.env` y configura `ruby_llm` con tu clave de API.
   Puedes usar [esta guía](https://kitt.lewagon.com/notion/students/1f78924af01480d7a4a8f6df8150c221) para obtener una clave de API gratuita. O puedes registrarte en OpenAI y obtener una clave de pago si quieres usar la IA más allá del límite gratuito.

4. Comprueba que tu clave funciona, directamente desde `irb`:
   ```ruby
   require "ruby_llm"
   RubyLLM.configure { |config| config.openai_api_key = "PASTE_YOUR_API_KEY_HERE" }
   chat = RubyLLM.chat
   puts chat.ask("Say hello!").content
   ```
   Deberías ver una respuesta del modelo de IA. Si no la ves, abre un ticket con el equipo docente para pedir ayuda.

## Messages

### Modelo Message

Empecemos con la capa de datos para los mensajes.

Cada `message` tiene:
- un `id` (nota: este debería ser opcional, ya que el repositorio lo asignará más tarde)
- un `role`: `"user"` (el humano) o `"assistant"` (el tutor de IA)
- un `content`: el texto real del mensaje

Escribe algo de código para implementar esto y haz un crash-test de tu modelo. Luego prueba tu código ejecutando `rake message`.

¿Todo en verde? ¡Bien! Es hora de hacer `git add`, `commit` y `push`.

### Repositorio Message

Ahora que tenemos un modelo que representa nuestros mensajes, necesitamos un repositorio para almacenarlos.

Por ahora, este repositorio es solo **en memoria**—pero igualmente debe inicializarse con una ruta a un archivo CSV (un `String`), aunque todavía no vaya a leer ni escribir nada en él. Vamos a añadir las funcionalidades de CSV más adelante. El comportamiento que queremos para el repositorio es:
- `create` un nuevo mensaje y asignarle un `id` único
- Obtener `all` los mensajes

Escribe algo de código para implementar esto y haz un crash-test de tu repositorio en `irb`. Luego prueba tu código ejecutando `rake message`.

¿Todo en verde? ¡Bien! Es hora de hacer `git add`, `commit` y `push`.

### MessageRouter y app

Ahora, empecemos a construir las funcionalidades reales de nuestra aplicación. Antes de poder implementar las funcionalidades de los mensajes, necesitamos poder lanzar realmente nuestra aplicación.

Para hacer esto, necesitamos un router y necesitamos completar el archivo `app.rb`. Vamos a llamar a este router `MessageRouter` (no solo `Router` como hicimos antes) — verás por qué en el próximo ejercicio, cuando construyamos un segundo router diferente.

El router es responsable de mostrar las diferentes funcionalidades que el usuario puede seleccionar y de dirigir la elección del usuario hacia la acción correspondiente del controller. El archivo `app.rb` es responsable de requerir todos los archivos necesarios, instanciar un router y ejecutar su método `run` para lanzar la aplicación.

Crea `app/routers/message_router.rb` y completa `app.rb` para implementar esto. Si te quedas atascado/a, puedes volver a [Food Delivery](https://kitt.lewagon.com/camps/<user.batch_slug>/challenges?path=02-OOP%2F04-Food-Delivery%2F01-Food-Delivery) y descargar la solución para inspirarte. **No hace falta instanciar el router con un controller** ya que todavía no lo tenemos. Simplemente imprime `TODO` por ahora cuando el usuario seleccione una tarea.

No hay `rake` para esta parte. Lanza tu aplicación ejecutando este comando en la terminal:

```bash
ruby app.rb
```

¿Todo funciona? ¡Bien! Es hora de hacer `git add`, `commit` y `push`.

### Funcionalidades de Messages

Pasemos a crear nuestro `MessagesController`. Aquí están las **acciones de usuario** que queremos implementar:
- `add` un nuevo mensaje
- `list` todos los mensajes

⚠️ No quieres intentar construir ambas funcionalidades al mismo tiempo. **Code en silo**, construyendo primero por completo la funcionalidad `add` y probándola en la terminal lanzando tu aplicación con `ruby app.rb`. Luego pasa a la funcionalidad `list` y haz lo mismo.

Tu `MessagesController` debe inicializarse con **un** argumento: una instancia de `MessageRepository`. Dentro de `#initialize`, construye tu propia sesión de chat con `RubyLLM.chat.with_instructions(...)`, pasándole un system prompt — por ahora, simplemente pon fijo tu idioma elegido directamente en el texto de ese prompt, por ejemplo _"You are a friendly Spanish tutor..."_. Un buen patrón sería incluir un método `private` en el controller llamado `#system_prompt` que devuelva ese string, para poder cambiarlo fácilmente más tarde.

También necesitarás crear una `MessagesView` para mostrar y pedir la información relevante al usuario.

La acción `add` es la parte de este ejercicio donde necesitarás interactuar con el LLM 🎉 Tu objetivo no es solo guardar el mensaje del usuario, sino también obtener una respuesta del tutor de IA y guardarla también. Entonces, cada vez que se llama a `#add`, en realidad se crean dos mensajes, uno del `user` y otro del `assistant`. También debes usar la view para mostrarle al usuario la respuesta del tutor para que la vea en la terminal.

Para probar tu controller, conéctalo a tu aplicación instanciándolo en `app.rb` y pasándolo a tu `MessageRouter`. Luego puedes hacer un crash-test de tu código lanzando tu aplicación:

```bash
ruby app.rb
```

`rake` también debería ayudarte a repasar todos estos pasos. 📝 **Nota:** nuestros specs nunca llaman a la API real — simulan la respuesta de la IA, así que `rake` nunca te cuesta nada.

📝 **Nota:** No hay un `rake` específico para las views en este ejercicio (a diferencia de los modelos y controllers). Siéntete libre de pensar de forma un poco artística 🎨 sobre lo que deben mostrar tus views, pero asegúrate de que funcionen correctamente ejecutando `ruby app.rb`.

Si todo funciona, así es como debería verse tu aplicación:

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

¿Todo en verde y funcionando? ¡Bien! Es hora de hacer `git add`, `commit` y `push`.

***

¡Buen trabajo, has completado este ejercicio! 🎉 Este es un gran logro. Dirígete a [AI Language Tutor (Part 2)](../02-AI-Language-Tutor-Part-2) para añadir soporte multi-idioma, guardar tu progreso y (opcionalmente) iniciar sesión. Es un poco más complejo, así que no te preocupes si no lo terminas hoy.
