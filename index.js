import express from "express";

const app = express();
const port = process.env.PORT ?? 3000;

app.listen(0, () => {
  console.log('Server listening on port: ' + port);
})