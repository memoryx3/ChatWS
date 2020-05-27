package avi.com.vk.controller;

import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.SendTo;
import org.springframework.stereotype.Controller;

@Controller
public class MessageController {

    @MessageMapping("/chat")
    @SendTo("topic/chating")
    public String message(String message) {
        System.out.println(message);
        return message;
    }
}
