local ls = require 'luasnip'
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local fmt = require('luasnip.extras.fmt').fmt

local M = {}

function M.setup()
  ls.add_snippets('go', {
    s('pl#', fmt([[fmt.Println(" #################################################### {} #################################################### ")]], { i(1) })),
    s('errg', t 'var errGeneric = errors.New("generic error")'),
    s('lgrd', fmt([[logger.Log.Debugf("{}")]], { i(1) })),
    s('lgri', fmt([[logger.Log.Infof("{}")]], { i(1) })),
    s('lgrf', fmt([[logger.Log.Infof("%+v", {})]], { i(1) })),
    s('lgre', fmt([[logger.Log.Errorf("{}")]], { i(1) })),
    s('lgrw', fmt([[logger.Log.Warningf("{}")]], { i(1) })),
    s('fpf', fmt([[fmt.Printf("%+v\n", {})]], { i(1) })),
    s(
      ';err',
      fmt(
        [[; err != nil {{
    {}
}}]],
        { i(1) }
      )
    ),
    s('rne', t 'return nil, err'),
    s('rse', fmt([[return {}, err]], { i(1) })),
    s(
      'tsess',
      fmt(
        [[
sess, _ := session.NewSessionWithOptions(session.Options{{
    Config: aws.Config{{Region: aws.String("eu-north-1")}},
    Profile: "tv2-int",
    SharedConfigState: session.SharedConfigEnable,
}})
configConfig, _ := config.New(sess)
]],
        {}
      )
    ),
    s(
      'tdyno',
      fmt(
        [[
db := dynamodb.New(sess, &aws.Config{{
    Endpoint: aws.String("http://localhost:8000"),
    Region:   aws.String("localhost"),
}})
]],
        {}
      )
    ),
    s('rpl', t 'replace bitbucket.org/pepedigital/tv2sc-sdk-go => /Users/tsasa/go/src/bitbucket.org/pepedigital/tv2sc-sdk-go'),
    s(
      'tconf',
      fmt(
        [[
awsConfig, err := config.LoadDefaultConfig(ctx)
if err != nil {{
    t.Fatal(err)
}}
]],
        {}
      )
    ),
  })
end

return M
