version = require('./src/version.json').version

module.exports = (grunt) ->

  # Run
  grunt.registerTask 'dev', ['connect:server', 'coffeelint','build:dev', 'watch:dev']
  grunt.registerTask 'dist', ['build:dist', 'connect:dist']


  DEV = process.env.NODE_ENV is 'development'
  grunt.log.writeflags {DEV}

  banner = "/*\n** v#{version}\n** #{new Date}\n** " + (if STANDALONE then '[STANDALONE]' else '[CORE]') + '\n*/\n'

  grunt.initConfig

    ##
    ## Building
    ##
    autoprefixer: app: files: 'app/tmp/main.css': 'app/tmp/main.css'
    browserify:   require('./grunt/grunt-browserify')(DEV, STANDALONE)
    copy:         require('./grunt/grunt-copy')()
    cssmin:       require('./grunt/grunt-cssmin')()
    html2js:      require('./grunt/grunt-html2js')(DEV, STANDALONE)
    jade:         require('./grunt/grunt-jade')(DEV, STANDALONE)
    less:         require('./grunt/grunt-less')(DEV, STANDALONE)
    uglify:       require('./grunt/grunt-uglify')(DEV, STANDALONE, banner)
    usebanner:    require('./grunt/grunt-usebanner')(banner)

    clean:
      app: ['app']
      tmp: ['app/tmp/']

    ##
    ## Tools
    ##
    bump:       require('./grunt/grunt-bump')()
    coffeelint: require('./grunt/grunt-coffeelint')()
    connect:    require('./grunt/grunt-connect')() # Dev :3000 Dist :3001

    ##
    ## Testing
    ##
    jasmine_node: require('./grunt/grunt-jasmine-node')()
    karma: require('./grunt/grunt-karma')()
    protractor: require('./grunt/grunt-protractor')()

  require('./grunt/grunt-watch')(grunt)



  # grunt.loadNpmTasks 'grunt-jasmine-node-new'
  grunt.loadNpmTasks 'grunt-autoprefixer'
  grunt.loadNpmTasks 'grunt-banner'
  grunt.loadNpmTasks 'grunt-browserify'
  grunt.loadNpmTasks 'grunt-bump'
  grunt.loadNpmTasks 'grunt-coffeelint'
  grunt.loadNpmTasks 'grunt-html2js'
  grunt.loadNpmTasks 'grunt-contrib-clean'
  grunt.loadNpmTasks 'grunt-contrib-connect'
  grunt.loadNpmTasks 'grunt-contrib-copy'
  grunt.loadNpmTasks 'grunt-contrib-cssmin'
  grunt.loadNpmTasks 'grunt-contrib-jade'
  grunt.loadNpmTasks 'grunt-contrib-less'
  grunt.loadNpmTasks 'grunt-contrib-uglify'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-karma'
  grunt.loadNpmTasks 'grunt-newer'
  # grunt.loadNpmTasks 'grunt-protractor-runner'
  grunt.loadNpmTasks 'grunt-shell'

  grunt.registerTask 'build:css', [
    'less:app'
    'autoprefixer:app'
    'cssmin:dist'
  ]

  # Build
  grunt.registerTask 'build:dev', [
    # 'build:css' we dont do this because Semantic build is slow
    'less:app'
    'autoprefixer:app'
    'browserify:dev'
    'html2js'
    'newer:uglify:lib'
    'copy:core'
    'jade:core'
  ]
  grunt.registerTask 'build:dist', [
    'clean:app'
    'build:css'
    'browserify:dist'
    'html2js'
    'uglify'
    'copy:core'
    'jade:core'
    'usebanner'
    'clean:tmp'
  ]

  # Run
  grunt.registerTask 'dev', ['connect:server', 'coffeelint','build:dev', 'watch:dev']
  grunt.registerTask 'dist', ['build:dist', 'connect:dist']
