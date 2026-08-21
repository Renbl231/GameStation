require('dotenv').config();
const axios = require('axios');

async function getAccessTokenIGDB() {
    const params = new URLSearchParams();
    params.append('client_id', process.env.IGDB_CLIENT_ID);
    params.append('client_secret', process.env.IGDB_CLIENT_SECRET);
    params.append('grant_type', 'client_credentials');

    const res = await axios.post('https://id.twitch.tv/oauth2/token', params, {
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' }
    });
    
    return res.data.access_token;
}

async function igdbRequest(endpoint, body) {
    const token = await getAccessTokenIGDB();
    return axios.post(`https://api.igdb.com/v4/${endpoint}`, body, {
        headers: {
            'Client-ID': process.env.IGDB_CLIENT_ID,
            'Authorization': `Bearer ${token}`,
            'Content-Type': 'text/plain',
            'Accept': 'application/json'
        }
    });
}


module.exports = { igdbRequest };