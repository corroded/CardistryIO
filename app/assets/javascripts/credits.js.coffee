l = -> console.log.apply(console, arguments)

class DomList
  constructor: (el) ->
    @el = el
    @list = []
    @nextId = 1

  add: (obj) ->
    id = @._getNextId()
    @._addObject(obj, id)
    @.updateDom()
    id

  remove: (id) ->
    @._buildNewListWithout(id)
    @.updateDom()

  updateDom: ->
    @el.html("")
    @el.append("<ul></ul>")
    for item in @list
      html = "<li>#{item.obj.toHtml()}</li>"
      @el.find("ul").append(html)

  findIdWhere: (predicate) ->
    for item in @list
      if predicate(item.obj)
        return item.id

  _buildNewListWithout: (id) ->
    newList = []
    for item in @list
      unless item.id == id
        newList.push(item)
    @list = newList

  _getNextId: ->
    id = @nextId
    @nextId += 1
    id

  _addObject: (obj, id) ->
    @list.push({
      id: @nextId
      obj: obj
    })

class Credit
  constructor: (username) ->
    @username = username.replace("@", "")

  toHtml: ->
    """
    <span data-username="#{@username}">
      @#{@username}
      <button type="button" data-behavior="remove-credit">Remove</button>
      <input type="hidden" name="credits[]" value="#{@username}">
    </span>
    """

loadExistingCredits = (f) ->
  el = $(".add-credits[data-json-url]")
  return unless el.length > 0
  url = el.attr("data-json-url")
  request = new AjaxRequest(url)
  request.run (json) -> f(json.credits)

$ ->
  list = new DomList($(".credit-list"))

  loadExistingCredits (users) ->
    for user in users
      credit = new Credit(user.username)
      list.add(credit)

  addBehavior "add-credit", (event) ->
    event.preventDefault()
    username = $(@).attr("data-username")
    $(@).remove()
    $("[data-behavior~=credit-user-search]").val("").focus()
    credit = new Credit(username)
    list.add(credit)

  addBehavior "remove-credit", () ->
    username = $(@).parents("[data-username]").attr("data-username")
    id = list.findIdWhere (credit) -> credit.username == username
    list.remove(id)

  searchUrl = $("[data-behavior~=credit-user-search]").data("creditable-users-url")
  $("[data-behavior~=credit-user-search]").sayt
    url: searchUrl
    markup: (users) ->
      transform = (acc, user) ->
        acc + """
          <li>
            <a href="#"
               data-username="#{user.username}"
               data-behavior="add-credit">
              @#{user.username}
            </a>
          </li>
        """
      items = users.reduce(transform, "")
      "<ul>#{items}</ul>"
