# frozen_string_literal: true

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

LoginUser.create(email: user1.email, password: 'abc123')
LoginUser.create(email: user2.email, password: '123abc')

AdminUser.create!(email: 'admin@example.com', password: 'password', password_confirmation: 'password') if Rails.env.development?

require 'tty-prompt'
require 'tty-spinner'

class SeedLoader
  attr_reader :base_dir, :prompt

  def initialize(base_dir)
    @base_dir = base_dir
    @prompt = TTY::Prompt.new
    load
  end

  private

  def load
    load_data :format
    load_data :access_right
    load_data :retention_policy
    load_data :producer
    load_data :material_flow
    load_data :representation_info
  end

  def load_data(klass_name)
    klass = begin
      "Teneo::DataModel::#{klass_name.to_s.classify}".constantize
    rescue NameError
      "#{klass_name.to_s.classify}".constantize
    end
    spinner = TTY::Spinner::new("[:spinner] Loading #{klass_name}(s) :file :name", interval: 4)
    spinner.auto_spin
    spinner.update(file: '...', name: '')
    spinner.start
    Dir.children(base_dir).select {|f| f =~ /\.#{klass_name}\.yml$/}.sort.each do |filename|
      spinner.update(file: "from '#{filename}'")
      path = File.join(base_dir, filename)
      data = YAML.load_file(path)
      case data
      when Array
        data.each do |x|
          (n = x[:name] || x['name']) && spinner.update(name: "object '#{n}'")
          klass.from_hash(x)
          spinner.update(name: '')
        end
      when Hash
        klass.from_hash(data)
      else
        prompt.error "Illegal file content: 'path' - either Array or Hash expected."
      end
      spinner.update(file: '...')
    end
    spinner.update(file: '- Done', name: '!')
    spinner.success
  end

end

dir = File.dirname __FILE__
SeedLoader.new(dir)
# SeedLoader.new(File.join dir, '..', 'data', 'seed')
