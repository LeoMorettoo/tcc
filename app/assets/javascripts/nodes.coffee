# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
ready = ->

  $BtnSalvar = $('#salvar')

  $('body').on 'click' , '#salvar' , (e) ->
    scenario = {name: $('#title_scenario').val() , node_id: $('#salvar').attr('data-id')}
    e.preventDefault()
    $.ajax '/scenarios',
        type: 'POST'
        dataType: 'json'
        data: {scenario}
        error: (jqXHR, textStatus, errorThrown) ->
            # $('body').append "AJAX Error: #{textStatus}"
            # deu ruim, tratar erro
        success: (data, textStatus, jqXHR) ->
          window.location.replace '/scenarios'



  $('body').on 'click' , '.ac-label' , (e) ->
    id = $(this).attr('data-id')
    $BtnSalvar.attr('data-id',id)


  $('.resultado').on "click",(e) ->
    e.preventDefault()

    $.ajax '/path_for_result',
        type: 'POST'
        dataType: 'json'
        data: {result: $(this).attr('id')}
        error: (jqXHR, textStatus, errorThrown) ->
            # $('body').append "AJAX Error: #{textStatus}"
            # deu ruim, tratar erro
        success: (data, textStatus, jqXHR) ->
          results = ''
          $('.ac-text').remove()
          $.each data, (index,resultado) ->
            index = index + 1
            results = results +
              '
              <div class="ac-sub">
              <input class="ac-input" id="ac-' + index + '" name="ac-' + index + '" type="checkbox" />
              <label class="ac-label" data-id="' + resultado.id + '" for="ac-' + index + '">Cenário ' + index + ' </label>
              <article class="ac-sub-text">
              ' + resultado.text + '
              </article>
              </div>
              '
          $divResultado =
            '<article class="ac-text">
            ' + results +  '
             </article><!--/ac-text--> '
          $('.ac').append($divResultado)



  $filters = $(".node-value-selector")
  $escolhas = $("#escolhas")
  $filters.on "change", ->
    variable = $(this).attr('id')
    condition = $(this).val()
    final_result = $(this).find(':selected').data('result')
    tree_id = $(this).find(':selected').data('tree')
    itemid = $(this).find(':selected').data('itemid')

    #adiciona a li
    $escolhas.append('<li>' + variable + ': ' + condition + '</li>')


    data_id = if itemid? then itemid else 0

    #adiciona o result
    if final_result
      $('#final_result').append('<p>' + final_result + '</p>')
      $('#final_result').append('<input type="text" placeholder="Titulo do Cenario" id="title_scenario">')
      $('#final_result').append('<button type="button" id="salvar" data-id="' + itemid + '" class="btn btn-success">Salvar</button>')


    #data_result = if final_result? then $('#final_result').append('<p>' + final_result + '</p>') else 0

    if !condition
      return false

    $.ajax '/conditions_sub_trees',
        type: 'POST'
        dataType: 'json'
        data: {variable:variable, condition:condition, tree_id:tree_id}
        error: (jqXHR, textStatus, errorThrown) ->
            # $('body').append "AJAX Error: #{textStatus}"
            # deu ruim, tratar erro
        success: (data, textStatus, jqXHR) ->
            selects_auxiliar = []
            selects = []

            $filters.each (i, v) ->
              selects[$(v).attr('id')] = []
              selects_auxiliar[$(v).attr('id')] = []
              $(v).children().remove()

            $.each data, (index, conjunto) ->
              $.each conjunto, (i, node) ->
                if $.inArray(node.condition, selects[node.variable]) == -1
                  selects_auxiliar[node.variable].push(node.condition)
                  if node.result == "f"
                    node.result = 0
                  selects[node.variable].push({'condition':node.condition,'id':node.id , 'result':node.result})


            $.each Object.keys(selects), (index, select) ->
              $select = $('#' + select)

              $.each selects[select], (i, option) ->
                $select.append('<option data-itemid="'+option.id+'" data-result="'+option.result+'" value="' + option.condition + '">' + option.condition + '</option>')

              text = if selects[select].length > 0 then 'Selecione uma' else 'Nenhuma'
              $select.prepend('<option selected value="">' + text + ' opção</option>')


$(document).ready(ready)
$(document).on('page:load', ready)
