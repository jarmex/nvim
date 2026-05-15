return {
  {
    'neo451/feed.nvim',
    cmd = 'Feed',
    ---@module 'feed'
    ---@type feed.config
    opts = {},
    config = function()
      require('feed').setup({
        ui = {
          order = { 'date', 'feed', 'tags', 'title', 'reading_time' },
          reading_time = {
            color = 'Comment',
            format = function(id, db)
              local cpm = 1000
              local content = db:get(id):gsub('%s+', ' ')
              local chars = v.fn.strchars(content)
              local time = math.ceil(chars / cpm)
              return string.format('(%s min)', time)
            end,
          },
          tags = {
            format = function(id, db)
              local icons = {
                nvimAndLua = '',
                angular = '',
                react = '',
                typescript = '',
                java = '',
                golang = '',
                python = '',
                finance = '💰',
                xkcd = '🧑‍💻',
                security = '🔒',
                programming = '💻',
              }

              local get_icon = function(name)
                if icons[name] then
                  return icons[name]
                end

                local has_mini, MiniIcons = pcall(require, 'mini.icons')
                if has_mini then
                  local icon = MiniIcons.get('filetype', name)

                  if icon then
                    return icon .. ' '
                  end
                end

                return name
              end

              local tags = v.tbl_map(get_icon, db:get_tags(id))
              table.sort(tags)

              return '[' .. table.concat(tags, ', ') .. ']'
            end,
          },
        },
        feeds = {
          comics = {
            { 'http://xkcd.com/rss.xml', name = 'xkcd' },
          },
          music = {
            { 'http://www.metalhammer.co.uk/rss' },
            { 'http://loudwire.com/feed/' },
            { 'http://www.blabbermouth.net/feed.rss' },
            { 'http://www.angrymetalguy.com/feed/' },
            { 'http://www.metalsucks.net/feed/rss/' },
            { 'http://feeds2.feedburner.com/metalinjection' },
          },
          tech = {
            frontendFrameworks = {
              react = {
                { 'https://overreacted.io/rss.xml' },
                { 'http://facebook.github.io/react/feed.xml' },
              },
              angular = {
                { 'https://blog.angular.io/feed' },
                { 'https://medium.com/feed/@vsavkin' },
                { 'https://netbasal.com/feed' },
                { 'http://feeds.feedburner.com/juristrumpflohner' },
              },
            },
            frontendGeneral = {
              { 'https://css-tricks.com/feed/' },
              { 'http://feeds.feedburner.com/JohnPapa' },
              { 'https://kentcdodds.com/blog/rss.xml' },
              { 'https://blog.nrwl.io/feed' },
              { 'http://feeds2.feedburner.com/leaverou' },
              { 'http://www.chriskrycho.com/feed.xml' },
              { 'https://coryrylan.com/feed.xml' },
              { 'https://www.bennadel.com/rss tech webdev' },
              { 'http://feeds.feedburner.com/Bludice tech webdev' },
            },
            design = {
              { 'http://rss1.smashingmagazine.com/feed/ tech design' },
              { 'http://feeds.feedburner.com/NirAndFar tech design' },
            },
            languages = {
              typescript = {
                { 'https://devblogs.microsoft.com/typescript/feed/' },
                { 'http://blogs.msdn.com/b/typescript/rss.aspx' },
                { 'https://effectivetypescript.com/atom.xml' },
              },
              nodeAndJs = {
                { 'https://cprss.s3.amazonaws.com/nodeweekly.com.xml' },
                { 'https://nodejs.org/en/feed/blog.xml' },
                { 'https://javascriptweekly.com/' },
                { 'https://nodesource.com/blog/rss' },
              },
              python = {
                { 'https://devblogs.microsoft.com/python/feed/' },
                { 'https://realpython.com/atom.xml' },
                { 'https://pbpython.com/feeds/all.atom.xml' },
              },
              golang = {
                { 'https://go.dev/blog/feed.atom' },
                { 'https://cprss.s3.amazonaws.com/golangweekly.com.xml' },
              },
              java = {
                { 'https://feeds.feedblitz.com/baeldung' },
                { 'https://devblogs.microsoft.com/java/feed/' },
              },
              nvimAndLua = {
                { 'https://this-week-in-neovim.org/rss' },
                { 'https://neovim.io/news.xml' },
                { 'http://www.lua.org/news.rss' },
                { 'https://medium.com/feed/@alpha2phi' },
                { 'https://phaazon.net/blog/feed' },
              },
            },
            programming = {
              { 'https://devblogs.microsoft.com/commandline/feed/' },
              { 'https://itsfoss.com/rss/' },
              { 'http://blog.cleancoder.com/atom.xml' },
              { 'http://feeds.feedburner.com/mariusschulz' },
              { 'http://thepracticaldev.com/feed' },
              { 'http://martinfowler.com/bliki/bliki.atom' },
            },
            techBlogs = {
              { 'http://artsy.github.io/feed' },
              { 'https://engineering.atspotify.com/feed/' },
              { 'https://www.etsy.com/codeascraft/rss' },
              { 'https://medium.com/feed/airbnb-engineering' },
              { 'https://netflixtechblog.com/feed' },
              { 'https://engineering.fb.com/feed/' },
              { 'https://github.blog/feed/' },
              { 'https://github.blog/engineering.atom' },
              { 'https://blog.developer.atlassian.com/feed/' },
              { 'https://dropbox.tech/feed' },
            },
          },
          finance = {
            { 'https://abnormalreturns.com/feed/' },
            { 'https://alephblog.com/feed/' },
            { 'https://ritholtz.com/feed/' },
            { 'http://www.thereformedbroker.com/feed/' },
            { 'http://awealthofcommonsense.com/feed/' },
          },
          productivity = {
            { 'https://fortelabs.com/blog/blog/feed/' },
            { 'https://jamesclear.com/feed' },
            { 'https://calnewport.com/blog/feed/' },
            { 'http://blog.trello.com/feed/' },
            { 'https://timeular.com/feed/' },
            { 'https://www.eleanorkonik.com/blog/rss/' },
            { 'https://nesslabs.com/blog/feed' },
          },
          security = {
            { 'http://www.schneier.com/blog/index.rdf' },
            { 'http://krebsonsecurity.com/feed/' },
            { 'http://feeds.feedburner.com/GoogleOnlineSecurityBlog' },
          },
        },
      })
    end,
  },
}
