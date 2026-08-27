
require('dotenv').config()
const minioClient = require('../config/minio')
const minio = require('minio')
const axios = require('axios')
const sharp = require('sharp');

class StorageService {

  static getImageSizeByType(type) {
    const sizes = {
        'cover': { width: 800, height: 450 },
        'game_cover': { width: 528, height: 704 },
        'content': { width: 843, height: 474 },
        'banner': { width: 1312, height: 400 },
        'screenshot': { width: 1920, height: 1080 },
        'avatar': { width: 200, height: 200 },
        'logo': { width: 300, height: 150 }
    };

    return sizes[type] || null;
  }

  static async resizeImage(buffer, width, height) {
    try {
        return await sharp(buffer)
            .resize(width, height, {
                fit: 'cover',     
                position: 'center',
                withoutEnlargement: true
            })
            .toBuffer();
    } catch (error) {
        console.error('Ошибка изменения размера:', error);
        return buffer;
    }
  }

  static async uploadFileToBucket(file, prefix, slug = null, uniqueId = null, type = null, number = null) {
    let buffer = file.buffer;

    const size = this.getImageSizeByType(type);
    if (size) {
        buffer = await this.resizeImage(buffer, size.width, size.height);
    }

    const ext = file.originalname.split('.').pop();
    
    let name;
    if (slug) {
        name = `${slug}`;
        if (type !== null) name += `-${type}`;
        if (uniqueId !== null) name += `_${uniqueId}`;
        if (number !== null) name += `_${number}`;
    } else {
        name = `${Date.now()}_${Math.random().toString(36).substring(2, 8)}`;
    }
    
    const key = `${prefix}/${name}.${ext}`;

    await minioClient.putObject(
        process.env.AWS_BUCKET,
        key,
        buffer,
        buffer.length,
        { 'Content-Type': file.mimetype }
    );

    return { 
        key, 
        url: `${process.env.MINIO_PUBLIC_ENDPOINT}/${process.env.AWS_BUCKET}/${key}` 
    }
  }

  static async deleteFileFromBucket(key) {
      await minioClient.removeObject(process.env.AWS_BUCKET, key)
  }

  static async copyFile(sourceKey, destKey) {
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

  static async downloadAndSaveImage (imageUrl, prefix, slug, gameId, type, number = null) {
    if (!imageUrl) return null

    try {
        const response = await axios.get(imageUrl, {
            responseType: 'arraybuffer',
            timeout: 15000
        })

        const ext = imageUrl.split('.').pop().split('?')[0] || 'jpg'
        const buffer = Buffer.from(response.data)

        const file = {
            buffer,
            originalname: `temp.${ext}`,
            size: buffer.length,
            mimetype: response.headers['content-type'] || 'image/jpeg'
        }

        const { key } = await this.uploadFileToBucket(
            file,
            prefix,
            slug,
            gameId,
            type,
            number
        )

        return key
    } catch (error) {
        console.error(`Ошибка скачивания ${imageUrl}:`, error.message)
        return null
    }
  }

}

module.exports = StorageService