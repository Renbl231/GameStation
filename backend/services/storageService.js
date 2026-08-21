
require('dotenv').config()
const minioClient = require('../config/minio')
const minio = require('minio')

class StorageService {
  static async uploadFileToBucket(file, prefix, slug = null, uniqueId = null, type = null, number = null,) {
    const ext = file.originalname.split('.').pop()
    
    let name
    if (slug) {
        name = `${slug}`
        if (type !== null) name += `-${type}`
        if (number !== null) name += `_${number}`
        if (uniqueId !== null) name += `_${uniqueId}`
    } else {
        name = `${Date.now()}_${Math.random().toString(36).substring(2, 8)}`
    }
    
    const key = `${prefix}/${name}.${ext}`

    await minioClient.putObject(
        process.env.AWS_BUCKET,
        key,
        file.buffer,
        file.size,
        { 'Content-Type': file.mimetype }
    )

    return { 
        key, 
        url: `${process.env.MINIO_PUBLIC_ENDPOINT}/${process.env.AWS_BUCKET}/${key}` 
    }
  }

  static async deleteFileFromBucket(key) {
      await minioClient.removeObject(process.env.AWS_BUCKET, key)
  }

  static async copyFile(sourceKey, destKey) {П
    try {
      try {
        await minioClient.statObject(process.env.AWS_BUCKET, sourceKey)
      } catch (error) {
        if (error.code === 'NoSuchKey' || error.code === 'NotFound') {
          return false 
        }
        throw error
      }

      // Копируем
      const conditions = new minio.CopyConditions()
      await minioClient.copyObject(
        process.env.AWS_BUCKET,
        destKey,
        `/${process.env.AWS_BUCKET}/${sourceKey}`,
        conditions
      )
      
      return true

    } catch (error) {
        return false  
    }
  }

}

module.exports = StorageService