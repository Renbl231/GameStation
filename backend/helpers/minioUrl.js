require('dotenv').config()

function getPublicMinioUrl(objectName) {
  return `${process.env.MINIO_PUBLIC_ENDPOINT}/${process.env.AWS_BUCKET}/${objectName}`
}

module.exports = { getPublicMinioUrl }