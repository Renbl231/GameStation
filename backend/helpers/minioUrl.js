require('dotenv').config()

function getPublicMinioUrl(objectName) {
  return `${process.env.MINIO_PUBLIC_URL}/gamestation-media/${objectName}`
}

module.exports = { getPublicMinioUrl }