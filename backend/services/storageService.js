
require('dotenv').config()
const minioClient = require('../config/minio')

class StorageService {
  static async uploadFileToBucket(file, prefix) {
    const safeName = file.originalname.replace(/ /g, '_')
    const key = `${prefix}/${Date.now()}-${safeName}`

    await minioClient.putObject(
        process.env.AWS_BUCKET,
        key,
        file.buffer,
        file.size,
        { 'Content-Type': file.mimetype }
      )

      return { key }
  }

  static async deleteFileFromBucket(key) {
      await minioClient.removeObject(process.env.AWS_BUCKET, key)
  }
}

module.exports = StorageService