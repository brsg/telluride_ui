# TellurideUI

TellurideUI collaborates with [TelluridePipelime](https://github.com/brsg/telluride_pipeline) and [TellurideSensor](https://github.com/brsg/telluride_sensor) to provide an example of a [Broadway](https://github.com/dashbitco/broadway) pipeline consuming a stream of simulated IoT sensor reading messages from a `RabbitMQ` queue, in batches, computing some simple aggregate metrics over the stream of messages, and then publishlishing those metrics in a batch-oriented way to a queue on `RabbitMQ` by way of the [BroadwayRabbitMQ](https://github.com/dashbitco/broadway_rabbitmq) producer.  The point of this example is not the domain, which is contrived, but the mechanics of `Broadway` and Rabbit MQ working together.

TellurideUI implements a [Phoenix LiveView](https://github.com/phoenixframework/phoenix_live_view) dashboard that provides configuration and visualization of the Broadway pipeline. Here's an example screenshot:

<img src="images/screenshot.png" />


## Stack

[Elixir](https://elixir-lang.org/)

<img src="https://elixir-lang.org/images/logo/logo.png" height="60" />

[Phoenix Framework](https://www.phoenixframework.org/) (including [LiveView](https://github.com/phoenixframework/phoenix_live_view))

<img src="https://hexdocs.pm/phoenix/assets/logo.png" height="60" />

[RabbitMQ](https://www.rabbitmq.com/)

<img src="https://avatars.githubusercontent.com/u/96669?s=200&v=4" height="60" />

[Tailwind CSS 2](https://tailwindcss.com/)

<img src="https://raw.githubusercontent.com/github/explore/882462b8ecc337fd9c9b2572bc463a1cbc88fb6a/topics/tailwind/tailwind.png" height="60" />

[Alpine JS](https://github.com/alpinejs)

<img src="https://avatars.githubusercontent.com/u/59030169?s=200&v=4" height="60" />

with:
* [amqp](https://github.com/pma/amqp) library
* [TailwindUI](https://tailwindui.com)
