const con = require('./db');

const getAllZaehler = (req, res) => {
    con.query('SELECT * FROM Zaehler', (err, results) => {
        if (err) {
            console.error('Error fetching zaehler:', err.stack);
            res.status(500).send('Error fetching zaehler');
            return;
        }
        res.json(results);
    });
};

const getZaehlerById = (req, res) => {
    const zaehlerId = req.params.id;
    con.query('SELECT * FROM Zaehler WHERE id = ?', [zaehlerId], (err, result) => {
        if (err) {
            console.error('Error fetching zaehler:', err.stack);
            res.status(500).send('Error fetching zaehler');
            return;
        }
        if (result.length === 0) {
            res.status(404).send('Zaehler not found');
            return;
        }
        res.json(result[0]);
    });
};

const createZaehler = (req, res) => {
    const { isHauptzaehler, id_einbauort } = req.body;

    if (!req.body.isHauptzaehler) {
        res.status(400).send('isHauptzaehler is required');
        return;
    }

    con.query('INSERT INTO Zaehler (isHauptzaehler, id_einbauort) VALUES (?, ?)', [isHauptzaehler, id_einbauort], (err, result) => {
        if (err) {
            console.error('Error creating zaehler:', err.stack);
            res.status(500).send('Error creating zaehler');
            return;
        }
        res.status(201).send('Zaehler created successfully');
    });
};

const updateZaehler = (req, res) => {
    const zaehlerId = req.params.id;
    const { isHauptzaehler, id_einbauort } = req.body;

    con.query('SELECT * FROM Zaehler WHERE id = ?', [zaehlerId], (err, results) => {
        if (err) {
            console.error('Error checking zaehler:', err.stack);
            res.status(500).send('Error checking zaehler');
            return;
        }

        if (results.length === 0) {
            res.status(404).send('Zaehler not found');
            return;
        }

        con.query('UPDATE Zaehler SET isHauptzaehler = ?, id_einbauort = ? WHERE id = ?', [isHauptzaehler, id_einbauort, zaehlerId], (updateErr, updateResult) => {
            if (updateErr) {
                console.error('Error updating zaehler:', updateErr.stack);
                res.status(500).send('Error updating zaehler');
                return;
            }
            res.status(200).send('Zaehler updated successfully');
        });
    });
};

const deleteZaehlerById = (req, res) => {
    const zaehlerId = req.params.id;

    con.query('DELETE FROM Zaehler WHERE id = ?', [zaehlerId], (err, result) => {
        if (err) {
            console.error('Error deleting zaehler:', err.stack);
            res.status(500).send('Error deleting zaehler');
            return;
        }
        
        if (result.affectedRows === 0) {
            res.status(404).send('Zaehler not found');
            return;
        }

        res.status(200).send('Zaehler deleted successfully');
    });
};

const getKundeZaehlerstand = (req, res) => {
    const kundeId = req.params.kundeId;

    con.query(`SELECT zaehlerstand.*
               FROM zaehlerstand
               INNER JOIN Zaehler ON zaehlerstand.id_zaehler = Zaehler.id
               INNER JOIN Zaehlerbesitz ON Zaehler.id = Zaehlerbesitz.id_zaehler
               WHERE Zaehlerbesitz.id_kunde = ?`, [kundeId], (err, results) => {
        if (err) {
            console.error('Error fetching zaehlerstand:', err.stack);
            res.status(500).send('Error fetching zaehlerstand');
            return;
        }
        res.json(results);
    });
}

module.exports = {
    getAllZaehler,
    getZaehlerById,
    createZaehler,
    updateZaehler,
    deleteZaehlerById,
    getKundeZaehlerstand
};
