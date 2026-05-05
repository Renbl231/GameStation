
require('dotenv').config()
const minioClient = require('../config/minio')
const minio = require('minio')

class StorageService {
  static async uploadFileToBucket(file, prefix) {
    const ext = file.originalname.split('.').pop()
    const safeName = `${Date.now()}-${Math.random().toString(36).substr(2, 9)}.${ext}`
    const key = `${prefix}/${safeName}`

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

  static async copyFile(sourceKey, destKey) {
  try {
    // Пробуем stat (может не существовать)
    try {
      await minioClient.statObject(process.env.AWS_BUCKET, sourceKey)
    } catch (error) {
      if (error.code === 'NoSuchKey' || error.code === 'NotFound') {
        console.warn(`⚠️ Файл не найден (пропускаем): ${sourceKey}`)
        return false  // ← Пропуск!
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
    
    console.log(`✅ Скопировано: ${sourceKey} → ${destKey}`)
    return true
  } catch (error) {
    console.warn(`⚠️ Ошибка копирования (пропускаем): ${sourceKey}`, error.code || error.message)
    return false  // ← Всегда пропуск при ошибке!
  }
}

}

module.exports = StorageService