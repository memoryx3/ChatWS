package avi.com.vk.controller;


import avi.com.vk.Message;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.SendTo;
import org.springframework.stereotype.Controller;

@Controller
public class MessageController {

    @MessageMapping("/chat")
    @SendTo("topic/chating")
    public Message message(String message) {
        return new Message(message);
    }
}
