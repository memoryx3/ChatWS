<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>

<!DOCTYPE HTML>
<html>
<head>
  <title>Главная</title>
  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
  <link rel="stylesheet" type="text/css" href="${contextPath}/resources/css/style.css">
    <script src="https://cdnjs.cloudflare.com/ajax/libs/sockjs-client/1.1.4/sockjs.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/stomp.js/2.3.3/stomp.min.js"></script>
    <script type="text/javascript">
        var stompClient = null;

        function setConnected(connected) {
            document.getElementById('connect').disabled = connected;
            document.getElementById('disconnect').disabled = !connected;
            document.getElementById('conversationDiv').style.visibility = connected ? 'visible' : 'hidden';
            document.getElementById('response').innerHTML = '';
        }

        function connect() {
            var socket = new SockJS('/chat');
            stompClient = Stomp.over(socket);
            stompClient.connect({},
            function(frame) {
                setConnected(true);
                console.log('Connected: ' + frame);
                stompClient.subscribe('/topic/chating', showMessage);
            });
        }

        function disconnect() {
            stompClient.disconnect();
            setConnected(false);
            console.log("Disconnected");
        }

        function sendMessage() {
            var message = document.getElementById('message').value;
            stompClient.send("/app/chat", {}, JSON.stringify(message));
        }

        function showMessage(payload) {
            var message = JSON.parse(payload.body);
            var messageText = message.content;
            var $textarea = document.getElementById("messages");
            $textarea.value = $textarea.value + messageText + "\n";
        }
    </script>

</head>
<body onload="connect();">
<div class="center">
<div>
  <sec:authorize access="!isAuthenticated()">
    <a href="/login"><button>Войти</button></a>
    <a href="/registration"><button>Зарегистрироваться</button></a>
  </sec:authorize>
  <sec:authorize access="isAuthenticated()">
     <p>Привет, <b>${pageContext.request.userPrincipal.name}</b>!</p>
     <a href="/logout"><button>Выйти</button></a>
     <button id="connect" onclick="connect();">Соединение</button>
  </sec:authorize>
</div>
<div id="chatbox">
        <p id="response"></p>
        <textarea id="messages" rows="20" cols="50" readonly="readonly"></textarea>
</div>
<sec:authorize access="isAuthenticated()">
    <form name="message" action="">
        <input name="usermsg" type="text" id="message" size="40"/>
        <input type="button" name="submitmsg" value="Send..." onclick="sendMessage();"/>
    </form>
</sec:authorize>
</div>
</body>
</html>