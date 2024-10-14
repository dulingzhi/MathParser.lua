local c={}local t={}local o={}local function a(e)local n=t[e]if n then
return n
end
if o[e]then
error('critical dependency',2)end
o[e]=true
n=c[e]()o[e]=false
t[e]=n
return n
end
c['Helpers/Helpers']=(function(...)local l=string.char
local t=string.match
local r=string.gmatch
local c=table.insert
local a=string.utf8len or string.len
local i=string.utf8sub or string.sub
local n={}function n.stringToTable(o)local e={}for n=1,a(o)do
local n=i(o,n,n)c(e,n)end
return e
end
function n.createPatternLookupTable(o)local e={}for n=0,255 do
local n=l(n)if t(n,o)then
e[n]=true
end
end
return e
end
function n.makeTrie(e)local t={}for e,o in ipairs(e)do
local e=t
for n in r(o,".")do
e[n]=e[n]or{}e=e[n]end
e.value=o
end
return t
end
return n end)c['Evaluator/Evaluator']=(function(...)local e=a("Helpers/Helpers")local m=(unpack or table.unpack)local p=table.insert
local a={Unary={["-"]=function(e)return-e end,["!"]=function(e)return not e end,},Binary={["+"]=function(e,n)return e+n end,["-"]=function(e,n)return e-n end,["/"]=function(n,e)return n/e end,["*"]=function(n,e)return n*e end,["^"]=function(e,n)return e^n end,["%"]=function(e,n)return e%n end,["=="]=function(e,n)return e==n end,["!="]=function(n,e)return n~=e end,[">"]=function(n,e)return n>e end,["<"]=function(e,n)return e<n end,[">="]=function(e,n)return e>=n end,["<="]=function(e,n)return e<=n end,["||"]=function(n,e)return not not n or not not e end,["||||"]=function(n,e)return not not n or not not e end,["&&"]=function(e,n)return not not(e and n)end,[":="]=function(n,o,t,e)e[n]=o end,}}local s={sin=math.sin,cos=math.cos,tan=math.tan,asin=math.asin,acos=math.acos,atan=math.atan,floor=math.floor,ceil=math.ceil,abs=math.abs,sqrt=math.sqrt,log=math.log,log10=math.log10,exp=math.exp,rad=math.rad,deg=math.deg}local function h(t,o,n,e)local t=t
local r=o or{}local l=n or a
local c=e or{}local n,i,d,u,o
local function f(n,...)for e=1,select('#',...)do
p(n,(select(e,...)))end
end
function n(e)local t=e.Value
local n=l.Unary[t]assert(n,"invalid operator: "..tostring(t))local o=o(e.Operand)return n(o,e)end
function i(e)local n=e.Value
local t=e.Left
local a=e.Right
local n=l.Binary[n]assert(n,"invalid operator")local t=o(t)local o=o(a)return n(t,o,e,r)end
function d(e)local o=not(not e.Operand)if o then
return n(e)end
return i(e)end
function u(n)local e=n.FunctionName
local t=n.Arguments
local n=c[e]or s[e]assert(n,"invalid function call: "..tostring(e))local e={}for t,n in ipairs(t)do
f(e,o(n))end
return n(m(e))end
function o(n)local e=n.TYPE
if e=="Constant"then
return tonumber(n.Value)elseif e=="Variable"then
local e=r[n.Value]if e==nil then
return tostring(n.Value)end
return e
elseif e=="Operator"or e=="UnaryOperator"then
return d(n)elseif e=="FunctionCall"then
return u(n)elseif e=="String"then
return tostring(n.Value)end
return error("Invalid node type: "..tostring(e).." ( You're not supposed to see this error message. )")end
local function i(i,n,o,e)t=i
r=n or{}l=o or a
c=e or s
end
local function e()assert(t,"No expression to evaluate")return o(t)end
return{resetToInitialState=i,evaluate=e}end
return h
end)c['Lexer/Lexer']=(function(...)local e=a("Helpers/Helpers")local n=a("Lexer/TokenFactory")local h=e.makeTrie
local v=e.stringToTable
local e=e.createPatternLookupTable
local c=table.concat
local o=table.insert
local g=string.rep
local b=string.reverse
local P=string.gsub
local E=n.createConstantToken
local O=n.createVariableToken
local k=n.createParenthesesToken
local V=n.createOperatorToken
local x=n.createCommaToken
local y=n.createStrToken
local s="+------------------------------+"local L="Expected a number after the 'x' or 'X'"local S="Expected a number after the decimal point"local A="Expected a number after the exponent sign"local n="Invalid character '%s'. Expected whitespace, parenthesis, comma, operator, or number."local N="No charStream given"local p={"+","-","*","/","^","%","==","!","!=",">","<",">=","<=","||","||||",'&&',":=",}local m=h(p)local U=e("%s")local a=e("%d")local H=e("[a-zA-Z_%.]")local T=e("[%da-fA-F]")local w=e("[+-]")local R=e("[eE]")local C=e("[xX]")local Y=e("[a-zA-Z0-9_%.]")local _=e("[()]")local function F(n,t,u)local d={}local i={}local l,r,e
if n then
n=n
l=v(n)r=l[u or 1]e=u or 1
d[n]=l
end
local n=(t and h(t))or m
local F=t or p
local f=n
local function n()return l[e+1]or"\0"end
local function t(n)local n=e+(n or 1)local o=l[n]or"\0"e=n
r=o
return o
end
local function u(n,o)local e=e+(o or 0)local e=g(" ",e-1).."^"local e="\n"..c(l).."\n"..e.."\n"..n
return e
end
local function B()local e=i
if#e>0 then
local e=c(e,"\n"..s)error("Lexer errors:".."\n"..s..e.."\n"..s)end
end
local function I(e)local e=(e or r)return a[e]or(e=="."and a[n()])end
local function g(l)o(l,t())local e=T[n()]if not e then
local e=u(L,1)o(i,e)end
repeat
o(l,t())e=T[n()]until not e
return l
end
local function T(e)o(e,t())local l=a[n()]if not l then
local e=u(S,1)o(i,e)end
repeat
o(e,t())l=a[n()]until not l
return e
end
local function s(e)o(e,t())if w[n()]then
o(e,t())end
local l=a[n()]if not l then
local e=u(A,1)o(i,e)end
repeat
o(e,t())l=a[n()]until not l
return e
end
local function S()local e={r}local l=false
local l=false
local l=false
if r=='0'and C[n()]then
return tonumber(c(g(e)),16)end
while a[n()]do
o(e,t())end
if n()=="."then
e=T(e)end
local n=n()if R[n]then
e=s(e)end
return tonumber(c(e))end
local function u()local r={r}local a=f
local l=l
local n=e
local e=1
while true do
local n=l[n+e]if not n or a[n]or n==")"or n==","then break end
e=e+1
o(r,n)end
if e>0 then
t(e-1)end
return c(r)end
local function s()local o,e={},0
local l
repeat
e=e+1
o[e]=r
local e=n()until not(Y[e]and t())return c(o)end
local function c()if I(r)then
local n=S()return E(n,e)end
local n=b(P(b(u()),'^%s+',''))return y(n,e)end
local function a()local n=f
local l=l
local r=e
local e
local o=0
while true do
local t=l[r+o]n=n[t]if not n then break end
e=n.value
o=o+1
end
if not e then return end
t(#e-1)return e
end
local function o()local n=r
if U[n]then
return
elseif _[n]then
return k(n,e)elseif H[n]then
return O(s(),e)elseif n==","then
return x(e)else
local n=a()if n then
return V(n,e)end
return c()end
end
local function a()local l,e={},0
local n=r
while n~="\0"do
local o=o()if o then
e=e+1
l[e]=o
end
n=t()end
return l
end
local function t(n,o)if n then
n=n
l=d[n]or v(n)r=l[1]e=1
d[n]=l
end
f=(o and h(o))or m
F=o or p
end
local function e()assert(l,N)i={}local e=a()B()return e
end
return{resetToInitialState=t,run=e}end
return F
end)c['Lexer/TokenFactory']=(function(...)local e={}function e.createConstantToken(e,n)return{TYPE="Constant",Value=e,Position=n}end
function e.createVariableToken(n,e)return{TYPE="Variable",Value=n,Position=e}end
function e.createParenthesesToken(n,e)return{TYPE="Parentheses",Value=n,Position=e}end
function e.createOperatorToken(e,n)return{TYPE="Operator",Value=e,Position=n}end
function e.createCommaToken(e)return{TYPE="Comma",Value=",",Position=e}end
function e.createStrToken(n,e)return{TYPE="String",Value=n,Position=e}end
return e end)c['Parser/Parser']=(function(...)local n=a("Helpers/Helpers")local e=a("Parser/NodeFactory")local R=n.stringToTable
local p=table.insert
local n=table.concat
local S=math.max
local b=math.min
local m=string.rep
local L=e.createUnaryOperatorNode
local _=e.createOperatorNode
local F=e.createFunctionCallNode
local a=20
local Y="No tokens given"local y="No tokens to parse"local O="Expected EOF, got '%s'"local x="Unexpected token: '%s' in <primary>, expected constant, variable or function call"local c="Expected expression, got EOF"local T="Expected ')', got EOF"local v="Expected ',' or ')', got '%s'"local i="<No charStream, error message: %s>"local h={Unary={["-"]=7,["!"]=7,},Binary={[":="]=1,["&&"]=2,["||"]=3,["||||"]=3,["=="]=4,["!="]=4,[">"]=4,["<"]=4,[">="]=4,["<="]=4,["+"]=5,["-"]=5,["*"]=6,["/"]=6,["%"]=6,["^"]=7,},RightAssociativeBinaryOperators={["^"]=true},}local e={}local function g(r,n,o,d,u)local l,e
if r then
l=o or 1
e=r[l]end
local t=n or h
local d=d
local s=u
local function f(e)return r[l+(e or 1)]end
local function n(n)local n=l+(n or 1)local o=r[n]l=n
e=o
return o
end
local function g(n)local e=n or e
if not t.Binary then return end
return e and e.TYPE=="Operator"and t.Binary[e.Value]end
local function k(n)local e=n or e
if not t.Unary then return end
return e and e.TYPE=="Operator"and t.Unary[e.Value]end
local function E(n)local e=n or e
if not t.RightAssociativeBinaryOperators then return end
return e and e.TYPE=="Operator"and t.RightAssociativeBinaryOperators[e.Value]end
local function V()local n=f()if not n then
if s[e.Value]~=nil then
return true,true
end
end
if e.TYPE=="Variable"and n.TYPE=="Parentheses"and n.Value=="("then
return true
end
if s[e.Value]~=nil then
return true,true
end
end
local function P(e)return e and t.Binary[e.Value]end
local function o(o,...)if not d then
return i:format(o)end
local n=R(d)local t=o:format(...)local e=(not e and#n+1)or e.Position
local o={}for e=S(1,e-a),b(e+a,#n)do
p(o,n[e])end
local n=table.concat(o)local e=m(" ",e-1).."^"return"\n"..n.."\n"..e.."\n"..t
end
local m,i,u,b,a
function m(l)local r=e.Value
n(2)local t={}while not l do
local l=a()p(t,l)if not e then
local e=f(-1)if e and e.TYPE=="Comma"then
error(o(c))end
error(o(T))break
elseif e.Value==")"then
break
elseif e.TYPE=="Comma"then
n()else
error(o(v,e.Value))end
end
if not l then
n()else
n(-1)end
return F(r,t)end
function i(r)local t=u()while g(e)do
local l=P(e)if l<=r and not E(e)then
break
end
local e=e
if not n()then
error(o(c))end
local n=i(l)t=_(e.Value,t,n)end
return t
end
function u()if not k(e)then
return b()end
local t=e.Value
if not n()then
error(o(c))end
local e=u()return L(t,e)end
function b()local t=e
if not t then return end
local r=t.Value
local l=t.TYPE
if l=="Parentheses"and r=="("then
n()local t=a()if not e or e.Value~=")"then
error(o(T))end
n()return t
elseif l=="Variable"then
local o,e=V()if o then
return m(e)end
n()return t
elseif l=="Constant"or l=="String"then
n()return t
end
error(o(x,r))end
function a()local e=i(0)return e
end
local function c(n,a,o,c,i)assert(n,Y)r=n
l=o or 1
e=n[l]t=a or h
d=c
s=i
end
local function t(n)assert(r,y)local t=a()if e and not n then
error(o(O,e.Value))end
return t
end
return{resetToInitialState=c,parse=t}end
return g
end)c['Parser/NodeFactory']=(function(...)local e={}function e.createUnaryOperatorNode(n,e)return{TYPE="UnaryOperator",Value=n,Operand=e}end
function e.createOperatorNode(o,n,e)return{TYPE="Operator",Value=o,Left=n,Right=e}end
function e.createFunctionCallNode(n,e)return{TYPE="FunctionCall",FunctionName=n,Arguments=e}end
return e end)c['MathParser']=(function(...)local e=a("Helpers/Helpers")local i=a("Evaluator/Evaluator")local c=a("Lexer/Lexer")local u=a("Parser/Parser")local e={}function e:tokenize(e)if self.cachedTokens[e]then
return self.cachedTokens[e]end
self.Lexer.resetToInitialState(e,self.operators)local n=self.Lexer.run()self.cachedTokens[e]=n
return n
end
function e:parse(n,e)if self.cachedASTs[e]then
return self.cachedASTs[e]end
self.Parser.resetToInitialState(n,self.operatorPrecedenceLevels,nil,e,self.functions)local n=self.Parser.parse()self.cachedASTs[e]=n
return n
end
function e:evaluate(e,o)if o and self.cachedResults[e]~=nil then
return self.cachedResults[e]end
self.Evaluator.resetToInitialState(e,self.variables,self.operatorFunctions,self.functions)local n=self.Evaluator:evaluate()if o then
self.cachedResults[e]=n
end
return n
end
function e:solve(e)return self:evaluate(self:parse(self:tokenize(e),e))end
function e:addVariable(n,e)self.variables=self.variables or{}self.variables[n]=e
self.cachedResults={}end
function e:addVariables(e)for n,e in pairs(e)do
self:addVariable(n,e)end
self.cachedResults={}end
function e:addFunction(e,n)self.functions=self.functions or{}self.functions[e]=n
self.cachedResults={}end
function e:removeFunction(e)if self.functions and self.functions[e]then
self.functions[e]=nil
self.cachedResults={}end
end
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
function e:resetToInitialState(n,e,o,t,l)self.operatorPrecedenceLevels=n
self.variables=e
self.operatorFunctions=o
self.operators=t
self.functions=l
self.cachedTokens={}self.cachedASTs={}self.cachedResults={}end
local a={}function a:new(a,o,l,r,t)local n={}for e,t in pairs(e)do
n[e]=t
end
o=o or{}o['false']=false
o['true']=true
n.operatorPrecedenceLevels=a
n.variables=o
n.operatorFunctions=l
n.operators=r
n.functions=t
n.cachedTokens={}n.cachedASTs={}n.cachedResults={}n.Lexer=c(nil,r)n.Parser=u(nil,a)n.Evaluator=i(nil,o,l,t)return n
end
return a
end)local e,n="LibFormula-1.0",1
local n,e=LibStub and LibStub:NewLibrary(e,n)or{}if not n then return end
local e={}function n:CreateInstance()return e:new()end
local o=a('MathParser')function e:new()local e=setmetatable({__vm=o:new()},{__index=self})assert(e.__vm,'Invalid instance object')return e
end
function e:addFunc(n,e)self.__vm:addFunction(n,e)end
function e:removeFunc(e)self.__vm:removeFunction(e)end
function e:exec(e)return self.__vm:evaluate(e)end
function e:parse(e)return self.__vm:parse(self.__vm:tokenize(e),e)end
function e:perform(e)return self.__vm:solve(e)end
return n
