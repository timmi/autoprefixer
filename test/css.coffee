CSS   = require('../lib/autoprefixer/css')
cases = require('./lib/cases')
utils = require('../lib/autoprefixer/utils')

describe 'CSS', ->
  beforeEach ->
    @nodes = cases.load('css')
    @css   = new CSS(@nodes.stylesheet)

  describe 'eachKeyframes()', ->

    it 'should iterate all keyframes', ->
      names = []
      @css.eachKeyframes (i) -> names.push(i.rule.name)
      names.should.eql ['coloring', 'moving']

  describe 'containKeyframes()', ->

    it 'should find keyframes with same name and prefix', ->
      css = new CSS(cases.load('css.prefix').stylesheet)

      css.containKeyframes(name: 'one').should.be.true
      css.containKeyframes(name: 'one', vendor: '-webkit-').should.be.true

      css.containKeyframes(name: 'one1').should.be.false
      css.containKeyframes(name: 'one', vendor: '-moz-').should.be.false

  describe 'addKeyframes()', ->

    it 'should add keyframes in iteration', ->
      @css.eachKeyframes (i) =>
        clone = utils.clone(i.rule, name: i.rule.name + '1')
        @css.addKeyframes(i.number, clone)
      cases.compare(@nodes, 'css.double')

    it 'should not double keyframes', ->
      @css.eachKeyframes (i) =>
        clone = utils.clone(i.rule, name: i.rule.name + '1')
        @css.addKeyframes(i.number, clone)
        @css.addKeyframes(i.number, clone)
      cases.compare(@nodes, 'css.double')

  describe 'removeKeyframes()', ->

    it 'should remove keyframes in interation', ->
      names = []

      @css.eachKeyframes (i) =>
        names.push(i.rule.name)
        @css.removeKeyframes(i.number) if i.rule.name == 'coloring'

      cases.compare(@nodes, 'css.remove')
      names.should.eql ['coloring', 'moving']

  describe 'eachDeclaration()', ->

    it 'should iterate declarations', ->
      nodes = cases.load('css.declarations')
      css   = new CSS(nodes.stylesheet)

      decls = []
      css.eachDeclaration (i) ->
        decls.push(i.node.property + ' ' + i.node.value)
      decls.should.eql ['color black'
                        'color white'
                        'color red'
                        'position relative'
                        'width 320px'
                        'width 1000px']

    it 'should set prefix to rule', ->
      css      = new CSS(cases.load('css.prefix').stylesheet)
      prefixes = []

      css.eachDeclaration (i) -> prefixes.push(i.rule.prefix)
      prefixes.should.eql ['-webkit-', undefined]


