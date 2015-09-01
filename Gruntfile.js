module.exports = (grunt) ->

  # Run
  grunt.registerTask 'dev', ['connect:server', 'coffeelint','build:dev', 'watch:dev']
  grunt.registerTask 'dist', ['build:dist', 'connect:dist']


  version = require('./src/fantasy-core/coffee/version.json').version


  DEV = process.env.NODE_ENV is 'development'
  STANDALONE = process.env.CORKHAT_STANDALONE is '1'

  grunt.log.writeflags {DEV, STANDALONE}

  banner = "/*\n** v#{version}\n** #{new Date}\n** " + (if STANDALONE then '[STANDALONE]' else '[CORE]') + '\n*/\n'

  grunt.initConfig

    ##
    ## Building
    ##
    autoprefixer: app: files: 'app/tmp/main.css': 'app/tmp/main.css'