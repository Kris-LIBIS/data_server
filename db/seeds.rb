# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
require 'securerandom'

user1 = Teneo::DataModel::User.create(uuid: SecureRandom.uuid, email: 'user1@example.com', first_name: 'First', last_name: 'User')
user2 = Teneo::DataModel::User.create(uuid: SecureRandom.uuid, email: 'user2@example.com', first_name: 'Second', last_name: 'User')
user3 = Teneo::DataModel::User.create(uuid: SecureRandom.uuid, email: 'user3@example.com', first_name: 'Third', last_name: 'User')
org1 = Teneo::DataModel::Organization.create(name: 'Organization1', inst_code: 'INS1', ingest_dir: '/nas/vol03/ingest/org1', description: 'First organization')
org2 = Teneo::DataModel::Organization.create(name: 'Organization2', inst_code: 'INS2', ingest_dir: '/nas/vol03/ingest/org2', description: 'Second organization')
org3 = Teneo::DataModel::Organization.create(name: 'Organization3', inst_code: 'INS3', ingest_dir: '/nas/vol03/ingest/org3', description: 'Third organization')
Teneo::DataModel::Membership.create(user: user1, organization: org1, role: 'uploader')
Teneo::DataModel::Membership.create(user: user1, organization: org2, role: 'ingester')
Teneo::DataModel::Membership.create(user: user1, organization: org3, role: 'admin')
Teneo::DataModel::Membership.create(user: user2, organization: org1, role: 'ingester')
Teneo::DataModel::Membership.create(user: user2, organization: org2, role: 'admin')
Teneo::DataModel::Membership.create(user: user2, organization: org3, role: 'uploader')
Teneo::DataModel::Membership.create(user: user3, organization: org1, role: 'admin')
Teneo::DataModel::Membership.create(user: user3, organization: org2, role: 'uploader')
Teneo::DataModel::Membership.create(user: user3, organization: org3, role: 'ingester')
Teneo::DataModel::Storage.create(organization: org1, name: 'Upload', protocol: 'NFS', options: {location: '/nas/vol04/upload/org1'})
Teneo::DataModel::Storage.create(organization: org2, name: 'Upload', protocol: 'NFS', options: {location: '/nas/vol04/upload/org2'})
Teneo::DataModel::Storage.create(organization: org3, name: 'Upload', protocol: 'NFS', options: {location: '/nas/vol04/upload/org3'})
Teneo::DataModel::Storage.create(organization: org1, name: 'Download', protocol: 'FTP', options: {host: 'ftp.org1.com', user: 'ftp', password: '123'})
Teneo::DataModel::Storage.create(organization: org2, name: 'Download', protocol: 'SFTP', options: {host: 'sftp.org2.com', user: 'ftp', password: '123'})
Teneo::DataModel::Storage.create(organization: org3, name: 'Download', protocol: 'GDRIVE', options: {credentials_file: 'credentials.json', path: '/data'})

