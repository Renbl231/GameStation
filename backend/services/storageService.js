
require('dotenv').config()
const minioClient = require('../config/minio')

class StorageService {

  static async uploadAvatarToBucket(file) {
    const key = `avatars/${Date.now()}-${file.originalname}`

    await minioClient.putObject(
      process.env.AWS_BUCKET,
      key,
      file.buffer,
      file.size,
      { 'Content-Type': file.mimetype }
    )

    return { key }
  }

  static async deleteAvatarFromBucket(key) {
    await minioClient.removeObject(process.env.AWS_BUCKET, key)
  }

}

module.exports = StorageService