require('dotenv').config();
const axios = require('axios');
const { param } = require('../routes');

async function getAccessTokenIGDB() {
    const params = new URLSearchParams();
    params.append('client_id', process.env.CLIENT_ID);
    params.append('client_secret', process.env.CLIENT_SECRET);
    params.append('grant_type', 'client-credentials'); // приложение запрашивает токен для себя

    const res = await axios.post('https://id.twitch.tv/oauth2/token', params);
    return res.data.access_token;
}


// Steam api
const steamStoreClient = axios.create({
  baseURL: 'http://store.steampowered.com',
  timeout: 15000,
  params: { cc: 'US', format: 'json' }
});
