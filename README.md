# TellurideUI

TellurideUI collaborates with [TelluridePipelime](https://github.com/brsg/telluride_pipeline) and [TellurideSensor](https://github.com/brsg/telluride_sensor) to provide an example of a [Broadway](https://github.com/dashbitco/broadway) pipeline consuming a stream of simulated IoT sensor reading messages from a `RabbitMQ` queue, in batches, computing some simple aggregate metrics over the stream of messages, and then publishlishing those metrics in a batch-oriented way to a queue on `RabbitMQ` by way of the [BroadwayRabbitMQ](https://github.com/dashbitco/broadway_rabbitmq) producer.  The point of this example is not the domain, which is contrived, but the mechanics of `Broadway` and Rabbit MQ working together.

TellurideUI implements a [Phoenix LiveView](https://github.com/phoenixframework/phoenix_live_view) dashboard that provides configuration and visualization of the Broadway pipeline.

