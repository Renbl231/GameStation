const express = require('express');
const cors = require('cors');
const app = express();

app.use(cors());
app.use(express.json());

app.use('/', require('./routes/index'));  

app.listen(3001, () => {
  console.log("Server: http://localhost:3001");
});
