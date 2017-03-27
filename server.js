/**
 * Created by ZhukovSD on 08.03.2017.
 */
const express = require('express');
const app = express();
const path = require('path');

app.set('port', (process.env.PORT || 3000));

app.use('/', express.static(path.join(__dirname, '/build')));

app.listen(app.get('port'), function() {
    console.log('Server started: http://localhost:' + app.get('port') + '/');
});