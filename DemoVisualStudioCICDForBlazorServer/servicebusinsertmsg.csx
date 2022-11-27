#r "nuget: Azure.Messaging.ServiceBus, 7.11.1"
#r "nuget: Azure.Identity, 1.9.0-beta.1"
using Azure.Messaging.ServiceBus;
using Azure.Identity;
using static System.Environment;
using static System.DateTime;
using static System.Console;

// https://learn.microsoft.com/en-us/azure/service-bus-messaging/service-bus-dotnet-get-started-with-queues?tabs=connection-string


WriteLine($"start {Now}");

var conn = GetEnvironmentVariable("sbconn");
var spaceName = Args[0];
var queueName = Args[1];

WriteLine($"conn={conn} queueName={queueName} namespace={spaceName}");

const int numOfMessages = 3;

// The Service Bus client types are safe to cache and use as a singleton for the lifetime
// of the application, which is best practice when messages are being published or read
// regularly.
//
// set the transport type to AmqpWebSockets so that the ServiceBusClient uses the port 443. 
// If you use the default AmqpTcp, you will need to make sure that the ports 5671 and 5672 are open

// TODO: Replace the <NAMESPACE-CONNECTION-STRING> and <QUEUE-NAME> placeholders
var clientOptions = new ServiceBusClientOptions()
{ 
    TransportType = ServiceBusTransportType.AmqpWebSockets
};
var client = new ServiceBusClient(conn, clientOptions);
var sender = client.CreateSender(queueName);

// create a batch 
using (ServiceBusMessageBatch messageBatch = await sender.CreateMessageBatchAsync()){

    for (int i = 1; i <= numOfMessages; i++)
    {
        // try adding a message to the batch
        if (!messageBatch.TryAddMessage(new ServiceBusMessage($"Message {i}")))
        {
            // if it is too large for the batch
            throw new Exception($"The message {i} is too large to fit in the batch.");
        }
    }
    
    try
    {
        // Use the producer client to send the batch of messages to the Service Bus queue
        await sender.SendMessagesAsync(messageBatch);
        Console.WriteLine($"A batch of {numOfMessages} messages has been published to the queue.");
    }
    finally
    {
        // Calling DisposeAsync on client types is required to ensure that network
        // resources and other unmanaged objects are properly cleaned up.
        await sender.DisposeAsync();
        await client.DisposeAsync();
    }
}
