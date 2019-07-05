package function;


import com.amazonaws.services.lambda.runtime.Context;
import com.amazonaws.services.lambda.runtime.RequestHandler;
import com.amazonaws.services.lambda.runtime.events.DynamodbEvent;
import com.amazonaws.services.dynamodbv2.model.AttributeValue;
import function.view.Response;

public class HelloLambdaHandler implements RequestHandler<DynamodbEvent, Response> {

    public HelloLambdaHandler() {
        System.out.println("lambda iniciando...");
    }

    @Override
    public Response handleRequest(DynamodbEvent input, Context context) {
        try {
            input.getRecords()
                    .forEach(record -> {
                        AttributeValue primary_key = record.getDynamodb().getKeys().get("primary_key");
                        System.out.println(primary_key.getS());
                        // AttributeValue primary_key_opt = record.getDynamodb().getNewImage().get("primary_key");
                        // System.out.println(primary_key_opt.getS());
                    });
            return new Response("Payment Processed Successfully");
        } catch (Exception e) {
            return new Response("Erro ao processar.");
        }
    }
}