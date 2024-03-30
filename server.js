const express = require('express');
const app = express();
const port = 8080;
const zaehlerHandlers = require('./zaehler-handlers');

app.use(express.json());

app.get('/zaehler', zaehlerHandlers.getAllZaehler);
app.get('/zaehler/:id', zaehlerHandlers.getZaehlerById);
app.post('/zaehler', zaehlerHandlers.createZaehler);
app.put('/zaehler/:id', zaehlerHandlers.updateZaehler);
app.delete('/zaehler/:id', zaehlerHandlers.deleteZaehlerById);
app.get('/kunde/:kundeId/zaehlerstand', zaehlerHandlers.getKundeZaehlerstand);


app.listen(port, () => {
    console.log(`Server is running on port ${port}`);
});
