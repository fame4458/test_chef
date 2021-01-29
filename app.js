const express = require("express");
const bodyParser = require("body-parser");

const app = express();
app.use(bodyParser.urlencoded({ extended: false }));
app.use(bodyParser.json());

const port = process.env.PORT || 8080;

const messages = [];

app.post("/messages", (req, res) => {
  const index = messages.findIndex((element) => element.text === req.body.text);
  console.log("index", index);
  if (index < messages.length && index != -1) {
    messages[index].count++;
  } else {
    messages.push({
      text: req.body.text,
      count: 1,
    });
  }
  console.log("test", req.body.text);
  res.send(200);
});

app.get("/messages", (req, res) => {
  res.send(messages);
});

app.listen(port, () => {
  console.log("server is running");
});
