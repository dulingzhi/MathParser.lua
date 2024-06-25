local c={}local a={}local o={}local function l(e)local n=a[e]if n then
return n
end
if o[e]then
error('critical dependency',2)end
o[e]=true
n=c[e]()o[e]=false
a[e]=n
return n
end
c['Helpers/Helpers']=(function(...)local a=string.char
local t=string.match
local r=string.gmatch
local o=table.insert
local n={}function n.stringToTable(n)local e={}for n in r(n,".")do
o(e,n)end
return e
end
function n.createPatternLookupTable(o)local e={}for n=0,255 do
local n=a(n)if t(n,o)then
e[n]=true
end
end
return e
end
function n.makeTrie(e)local o={}for e,a in ipairs(e)do
local e=o
for n in a:gmatch(".")do
e[n]=e[n]or{}e=e[n]end
e.value=a
end
return o
end
return n end)c['Evaluator/Evaluator']=(function(...)local e=l("Helpers/Helpers")local f=(unpack or table.unpack)local h=table.insert
local l={Unary={["-"]=function(e)return-e end,["!"]=function(e)return not e end,},Binary={["+"]=function(n,e)return n+e end,["-"]=function(e,n)return e-n end,["/"]=function(n,e)return n/e end,["*"]=function(e,n)return e*n end,["^"]=function(e,n)return e^n end,["%"]=function(e,n)return e%n end,["=="]=function(n,e)return n==e end,["!="]=function(n,e)return n~=e end,[">"]=function(e,n)return e>n end,["<"]=function(e,n)return e<n end,[">="]=function(n,e)return n>=e end,["<="]=function(n,e)return n<=e end,["||"]=function(n,e)return not not n or not not e end,["&&"]=function(e,n)return not not(e and n)end,[":="]=function(e,o,a,n)n[e]=o end,}}local s={sin=math.sin,cos=math.cos,tan=math.tan,asin=math.asin,acos=math.acos,atan=math.atan,floor=math.floor,ceil=math.ceil,abs=math.abs,sqrt=math.sqrt,log=math.log,log10=math.log10,exp=math.exp,rad=math.rad,deg=math.deg}local function p(e,n,t,o)local a=e
local r=n or{}local t=t or l
local i=o or{}local c,n,u,d,o
function c(e)local n=e.Value
local a=t.Unary[n]assert(a,"invalid operator: "..tostring(n))local n=o(e.Operand)return a(n,e)end
function n(e)local a=e.Value
local l=e.Left
local n=e.Right
local a=t.Binary[a]assert(a,"invalid operator")local t=o(n)local n=o(l,n)return a(n,t,e,r)end
function u(e)local o=not(not e.Operand)if o then
return c(e)end
return n(e)end
function d(n)local e=n.FunctionName
local a=n.Arguments
local n=i[e]or s[e]assert(n,"invalid function call: "..tostring(e))local e={}for a,n in ipairs(a)do
local n=o(n)h(e,n)end
return n(f(e))end
function o(e,o)local n=e.TYPE
if n=="Constant"then
return tonumber(e.Value)elseif n=="Variable"then
local n=r[e.Value]if n==nil then
if o~=nil then
return tostring(e.Value)end
return error("Variable not found: "..tostring(e.Value))end
return n
elseif n=="Operator"or n=="UnaryOperator"then
return u(e)elseif n=="FunctionCall"then
return d(e)end
return error("Invalid node type: "..tostring(n).." ( You're not supposed to see this error message. )")end
local function u(o,c,n,e)a=o
r=c or{}t=n or l
i=e or s
end
local function e()assert(a,"No expression to evaluate")return o(a)end
return{resetToInitialState=u,evaluate=e}end
return p end)c['Lexer/Lexer']=(function(...)local e=l("Helpers/Helpers")local o=l("Lexer/TokenFactory")local d=e.makeTrie
local T=e.stringToTable
local e=e.createPatternLookupTable
local i=table.concat
local n=table.insert
local P=string.rep
local g=o.createConstantToken
local E=o.createVariableToken
local S=o.createParenthesesToken
local A=o.createOperatorToken
local H=o.createCommaToken
local s="+------------------------------+"local N="Expected a number after the 'x' or 'X'"local U="Expected a number after the decimal point"local y="Expected a number after the exponent sign"local x="Invalid character '%s'. Expected whitespace, parenthesis, comma, operator, or number."local k="No charStream given"local h={"+","-","*","/","^","%","==","!","!=",">","<",">=","<=","||",'&&',":=",}local m=d(h)local O=e("%s")local l=e("%d")local _=e("[a-zA-Z_%.]")local b=e("[%da-fA-F]")local L=e("[+-]")local R=e("[eE]")local Y=e("[xX]")local F=e("[a-zA-Z0-9_%.]")local w=e("[()]")local function v(e,t,u)local f={}local c={}local r,a,o
if e then
e=e
r=T(e)a=r[u or 1]o=u or 1
f[e]=r
end
local e=(t and d(t))or m
local V=t or h
local p=e
local function e()return r[o+1]or"\0"end
local function t(e)local e=o+(e or 1)local n=r[e]or"\0"o=e
a=n
return n
end
local function u(n,e)local e=o+(e or 0)local e=P(" ",e-1).."^"local e="\n"..i(r).."\n"..e.."\n"..n
return e
end
local function C()local e=c
if#e>0 then
local e=i(e,"\n"..s)error("Lexer errors:".."\n"..s..e.."\n"..s)end
end
local function I(n)local n=(n or a)return l[n]or(n=="."and l[e()])end
local function P(a)n(a,t())local o=b[e()]if not o then
local e=u(N,1)n(c,e)end
repeat
n(a,t())o=b[e()]until not o
return a
end
local function v(o)n(o,t())local a=l[e()]if not a then
local e=u(U,1)n(c,e)end
repeat
n(o,t())a=l[e()]until not a
return o
end
local function b(o)n(o,t())if L[e()]then
n(o,t())end
local a=l[e()]if not a then
local e=u(y,1)n(c,e)end
repeat
n(o,t())a=l[e()]until not a
return o
end
local function s()local o={a}local r=false
local r=false
local r=false
if a=='0'and Y[e()]then
return i(P(o))end
while l[e()]do
n(o,t())end
if e()=="."then
o=v(o)end
local e=e()if R[e]then
o=b(o)end
return i(o)end
local function l()local o,n={},0
local r
repeat
n=n+1
o[n]=a
local e=e()until not(F[e]and t())return i(o)end
local function b()if I(a)then
local e=s()return g(e,o)end
local e=u(x:format(a))n(c,e)return
end
local function i()local n=p
local r=r
local a=o
local e
local o=0
while true do
local a=r[a+o]n=n[a]if not n then break end
e=n.value
o=o+1
end
if not e then return end
t(#e-1)return e
end
local function u()local e=a
if O[e]then
return
elseif w[e]then
return S(e,o)elseif _[e]then
return E(l(),o)elseif e==","then
return H(o)else
local e=i()if e then
return A(e,o)end
return b()end
end
local function l()local o,e={},0
local n=a
while n~="\0"do
local a=u()if a then
e=e+1
o[e]=a
end
n=t()end
return o
end
local function t(e,n)if e then
e=e
r=f[e]or T(e)a=r[1]o=1
f[e]=r
end
p=(n and d(n))or m
V=n or h
end
local function n()assert(r,k)c={}local e=l()C()return e
end
return{resetToInitialState=t,run=n}end
return v end)c['Lexer/TokenFactory']=(function(...)local e={}function e.createConstantToken(e,n)return{TYPE="Constant",Value=e,Position=n}end
function e.createVariableToken(e,n)return{TYPE="Variable",Value=e,Position=n}end
function e.createParenthesesToken(e,n)return{TYPE="Parentheses",Value=e,Position=n}end
function e.createOperatorToken(n,e)return{TYPE="Operator",Value=n,Position=e}end
function e.createCommaToken(e)return{TYPE="Comma",Value=",",Position=e}end
return e end)c['Parser/Parser']=(function(...)local n=l("Helpers/Helpers")local e=l("Parser/NodeFactory")local h=n.stringToTable
local p=table.insert
local n=table.concat
local Y=math.max
local f=math.min
local u=string.rep
local L=e.createUnaryOperatorNode
local _=e.createOperatorNode
local x=e.createFunctionCallNode
local l=20
local O="No tokens given"local k="No tokens to parse"local y="Expected EOF, got '%s'"local V="Unexpected token: '%s' in <primary>, expected constant, variable or function call"local c="Expected expression, got EOF"local T="Expected ')', got EOF"local g="Expected ',' or ')', got '%s'"local i="<No charStream, error message: %s>"local m={Unary={["-"]=7,["!"]=7,},Binary={[":="]=1,["&&"]=2,["||"]=3,["=="]=4,["!="]=4,[">"]=4,["<"]=4,[">="]=4,["<="]=4,["+"]=5,["-"]=5,["*"]=6,["/"]=6,["%"]=6,["^"]=7,},RightAssociativeBinaryOperators={["^"]=true},}local e={}local function E(t,n,o,a)local r,e
if t then
r=o or 1
e=t[r]end
local o=n or m
local d=a
local function s(e)return t[r+(e or 1)]end
local function n(n)local o=r+(n or 1)local n=t[o]r=o
e=n
return n
end
local function F(n)local e=n or e
if not o.Binary then return end
return e and e.TYPE=="Operator"and o.Binary[e.Value]end
local function E(n)local e=n or e
if not o.Unary then return end
return e and e.TYPE=="Operator"and o.Unary[e.Value]end
local function P(n)local e=n or e
if not o.RightAssociativeBinaryOperators then return end
return e and e.TYPE=="Operator"and o.RightAssociativeBinaryOperators[e.Value]end
local function v()local n=s()if not n then return end
return e.TYPE=="Variable"and n.TYPE=="Parentheses"and n.Value=="("end
local function b(e)return e and o.Binary[e.Value]end
local function a(o,...)if not d then
return i:format(o)end
local n=h(d)local a=o:format(...)local e=(not e and#n+1)or e.Position
local o={}for e=Y(1,e-l),f(e+l,#n)do
p(o,n[e])end
local n=table.concat(o)local e=u(" ",e-1).."^"return"\n"..n.."\n"..e.."\n"..a
end
local h,i,u,f,l
function h()local t=e.Value
n(2)local o={}while true do
local r=l()p(o,r)if not e then
local e=s(-1)if e.TYPE=="Comma"then
error(a(c))end
error(a(T))elseif e.Value==")"then
break
elseif e.TYPE=="Comma"then
n()else
error(a(g,e.Value))end
end
n()return x(t,o)end
function i(t)local o=u()while F(e)do
local r=b(e)if r<=t and not P(e)then
break
end
local e=e
if not n()then
error(a(c))end
local n=i(r)o=_(e.Value,o,n)end
return o
end
function u()if not E(e)then
return f()end
local e=e.Value
if not n()then
error(a(c))end
local n=u()return L(e,n)end
function f()local o=e
if not o then return end
local t=o.Value
local r=o.TYPE
if r=="Parentheses"and t=="("then
n()local o=l()if not e or e.Value~=")"then
error(a(T))end
n()return o
elseif r=="Variable"then
if v()then
return h()end
n()return o
elseif r=="Constant"then
n()return o
end
error(a(V,t))end
function l()local e=i(0)return e
end
local function c(n,a,c,l)assert(n,O)t=n
r=c or 1
e=n[r]o=a or m
d=l
end
local function o(o)assert(t,k)local n=l()if e and not o then
error(a(y,e.Value))end
return n
end
return{resetToInitialState=c,parse=o}end
return E end)c['Parser/NodeFactory']=(function(...)local e={}function e.createUnaryOperatorNode(n,e)return{TYPE="UnaryOperator",Value=n,Operand=e}end
function e.createOperatorNode(e,n,o)return{TYPE="Operator",Value=e,Left=n,Right=o}end
function e.createFunctionCallNode(e,n)return{TYPE="FunctionCall",FunctionName=e,Arguments=n}end
return e end)c['MathParser']=(function(...)local e=l("Helpers/Helpers")local u=l("Evaluator/Evaluator")local i=l("Lexer/Lexer")local d=l("Parser/Parser")local e={}function e:tokenize(e)if self.cachedTokens[e]then
return self.cachedTokens[e]end
self.Lexer.resetToInitialState(e,self.operators)local n=self.Lexer.run()self.cachedTokens[e]=n
return n
end
function e:parse(n,e)if self.cachedASTs[e]then
return self.cachedASTs[e]end
self.Parser.resetToInitialState(n,self.operatorPrecedenceLevels,nil,e)local n=self.Parser.parse()self.cachedASTs[e]=n
return n
end
function e:evaluate(e)if self.cachedResults[e]then
return self.cachedResults[e]end
self.Evaluator.resetToInitialState(e,self.variables,self.operatorFunctions,self.functions)local n=self.Evaluator:evaluate()self.cachedResults[e]=n
return n
end
function e:solve(e)return self:evaluate(self:parse(self:tokenize(e),e))end
function e:addVariable(e,n)self.variables=self.variables or{}self.variables[e]=n
self.cachedResults={}end
function e:addVariables(e)for e,n in pairs(e)do
self:addVariable(e,n)end
self.cachedResults={}end
function e:addFunction(n,e)self.functions=self.functions or{}self.functions[n]=e
self.cachedResults={}end
function e:addFunctions(e)for n,e in pairs(e)do
self:addFunction(n,e)end
self.cachedResults={}end
function e:setOperatorPrecedenceLevels(e)self.operatorPrecedenceLevels=e
self.cachedASTs={}end
function e:setVariables(e)self.variables=e
self.cachedResults={}end
function e:setOperatorFunctions(e)self.operatorFunctions=e
self.cachedResults={}end
function e:setOperators(e)self.operators=e
self.cachedTokens={}end
function e:setFunctions(e)self.functions=e
self.cachedResults={}end
function e:resetCaches()self.cachedTokens={}self.cachedASTs={}self.cachedResults={}end
function e:resetToInitialState(r,a,n,e,o)self.operatorPrecedenceLevels=r
self.variables=a
self.operatorFunctions=n
self.operators=e
self.functions=o
self.cachedTokens={}self.cachedASTs={}self.cachedResults={}end
local c={}function c:new(t,o,r,l,a)local n={}for e,a in pairs(e)do
n[e]=a
end
o=o or{}o['false']=false
o['true']=true
n.operatorPrecedenceLevels=t
n.variables=o
n.operatorFunctions=r
n.operators=l
n.functions=a
n.cachedTokens={}n.cachedASTs={}n.cachedResults={}n.Lexer=i(nil,l)n.Parser=d(nil,t)n.Evaluator=u(nil,o,r,a)return n
end
return c end)local e,n="LibFormula-1.0",1
local n,e=LibStub and LibStub:NewLibrary(e,n)or{}if not n then return end
local e={}function n:CreateInstance()return e:new()end
local o=l('MathParser')function e:new()return setmetatable({__vm=o:new()},{__index=self})end
function e:addFunc(e,n)assert(self.__vm,'Invalid instance object')self.__vm:addFunction(e,n)end
function e:exec(e)assert(self.__vm,'Invalid instance object')return self.__vm:evaluate(e)end
function e:parse(e)assert(self.__vm,'Invalid instance object')return self.__vm:parse(self.__vm:tokenize(e),e)end
return n
