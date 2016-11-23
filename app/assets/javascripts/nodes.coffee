# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
jQuery ->
  $filters = $(".node-value-selector")
  $filters.on "change", ->
    variable = $(this).attr('id')
    condition = $(this).val()
    data_id = if $(this).find(':selected').data('itemid')? then $(this).find(':selected').data('itemid') else 0
    if !condition
      return false

    $.ajax '/conditions_sub_trees',
        type: 'POST'
        dataType: 'json'
        data: {variable:variable, condition:condition, tree_id_conditio:data_id}
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
                  selects[node.variable].push({'condition':node.condition,'id':node.id})


            $.each Object.keys(selects), (index, select) ->
              $select = $('#' + select)

              $.each selects[select], (i, option) ->
                $select.append('<option data-itemid="'+option.id+'"value="' + option.condition + '">' + option.condition + '</option>')

              text = if selects[select].length > 0 then 'Selecione uma' else 'Nenhuma'
              $select.prepend('<option value="">' + text + ' opção</option>')
