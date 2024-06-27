local c={}local l={}local o={}local function a(e)local n=l[e]if n then
return n
end
if o[e]then
error('critical dependency',2)end
o[e]=true
n=c[e]()o[e]=false
l[e]=n
return n
end
c['Helpers/Helpers']=(function(...)local t=string.char
local r=string.match
local a=string.gmatch
local c=table.insert
local o=string.utf8len or string.len
local l=string.utf8sub or string.sub
local n={}function n.stringToTable(e)local n={}for o=1,o(e)do
local e=l(e,o,o)c(n,e)end
return n
end
function n.createPatternLookupTable(o)local n={}for e=0,255 do
local e=t(e)if r(e,o)then
n[e]=true
end
end
return n
end
function n.makeTrie(e)local l={}for e,o in ipairs(e)do
local e=l
for n in a(o,".")do
e[n]=e[n]or{}e=e[n]end
e.value=o
end
return l
end
return n end)c['Evaluator/Evaluator']=(function(...)local e=a("Helpers/Helpers")local p=(unpack or table.unpack)local T=table.insert
local a={Unary={["-"]=function(e)return-e end,["!"]=function(e)return not e end,},Binary={["+"]=function(e,n)return e+n end,["-"]=function(e,n)return e-n end,["/"]=function(e,n)return e/n end,["*"]=function(e,n)return e*n end,["^"]=function(n,e)return n^e end,["%"]=function(e,n)return e%n end,["=="]=function(n,e)return n==e end,["!="]=function(n,e)return n~=e end,[">"]=function(e,n)return e>n end,["<"]=function(e,n)return e<n end,[">="]=function(e,n)return e>=n end,["<="]=function(n,e)return n<=e end,["||"]=function(n,e)return not not n or not not e end,["&&"]=function(e,n)return not not(e and n)end,[":="]=function(o,e,l,n)n[o]=e end,}}local u={sin=math.sin,cos=math.cos,tan=math.tan,asin=math.asin,acos=math.acos,atan=math.atan,floor=math.floor,ceil=math.ceil,abs=math.abs,sqrt=math.sqrt,log=math.log,log10=math.log10,exp=math.exp,rad=math.rad,deg=math.deg}local function h(o,n,e,c)local t=o
local l=n or{}local r=e or a
local s=c or{}local f,d,i,c,o
function f(e)local l=e.Value
local n=r.Unary[l]assert(n,"invalid operator: "..tostring(l))local o=o(e.Operand)return n(o,e)end
function d(e)local n=e.Value
local t=e.Left
local a=e.Right
local n=r.Binary[n]assert(n,"invalid operator")local r=o(t)local o=o(a)return n(r,o,e,l)end
function i(e)local n=not(not e.Operand)if n then
return f(e)end
return d(e)end
function c(n)local e=n.FunctionName
local l=n.Arguments
local n=s[e]or u[e]assert(n,"invalid function call: "..tostring(e))local e={}for l,n in ipairs(l)do
local n=o(n)T(e,n)end
return n(p(e))end
function o(n)local e=n.TYPE
if e=="Constant"then
return tonumber(n.Value)elseif e=="Variable"then
local e=l[n.Value]if e==nil then
return tostring(n.Value)end
return e
elseif e=="Operator"or e=="UnaryOperator"then
return i(n)elseif e=="FunctionCall"then
return c(n)elseif e=="String"then
return tostring(n.Value)end
return error("Invalid node type: "..tostring(e).." ( You're not supposed to see this error message. )")end
local function i(c,n,o,e)t=c
l=n or{}r=o or a
s=e or u
end
local function e()assert(t,"No expression to evaluate")return o(t)end
return{resetToInitialState=i,evaluate=e}end
return h end)c['Lexer/Lexer']=(function(...)local e=a("Helpers/Helpers")local n=a("Lexer/TokenFactory")local f=e.makeTrie
local m=e.stringToTable
local e=e.createPatternLookupTable
local c=table.concat
local r=table.insert
local v=string.rep
local P=n.createConstantToken
local g=n.createVariableToken
local y=n.createParenthesesToken
local E=n.createOperatorToken
local k=n.createCommaToken
local V=n.createStrToken
local d="+------------------------------+"local x="Expected a number after the 'x' or 'X'"local L="Expected a number after the decimal point"local O="Expected a number after the exponent sign"local n="Invalid character '%s'. Expected whitespace, parenthesis, comma, operator, or number."local C="No charStream given"local u={"+","-","*","/","^","%","==","!","!=",">","<",">=","<=","||",'&&',":=",}local T=f(u)local U=e("%s")local a=e("%d")local F=e("[a-zA-Z_%.]")local b=e("[%da-fA-F]")local Y=e("[+-]")local S=e("[eE]")local H=e("[xX]")local _=e("[a-zA-Z0-9_%.]")local A=e("[()]")local function N(n,l,h)local s={}local i={}local o,t,e
if n then
n=n
o=m(n)t=o[h or 1]e=h or 1
s[n]=o
end
local n=(l and f(l))or T
local R=l or u
local h=n
local function n()return o[e+1]or"\0"end
local function l(n)local l=e+(n or 1)local n=o[l]or"\0"e=l
t=n
return n
end
local function p(l,n)local e=e+(n or 0)local e=v(" ",e-1).."^"local e="\n"..c(o).."\n"..e.."\n"..l
return e
end
local function v()local e=i
if#e>0 then
local e=c(e,"\n"..d)error("Lexer errors:".."\n"..d..e.."\n"..d)end
end
local function N(e)local e=(e or t)return a[e]or(e=="."and a[n()])end
local function w(e)r(e,l())local o=b[n()]if not o then
local e=p(x,1)r(i,e)end
repeat
r(e,l())o=b[n()]until not o
return e
end
local function x(e)r(e,l())local o=a[n()]if not o then
local e=p(L,1)r(i,e)end
repeat
r(e,l())o=a[n()]until not o
return e
end
local function d(e)r(e,l())if Y[n()]then
r(e,l())end
local o=a[n()]if not o then
local e=p(O,1)r(i,e)end
repeat
r(e,l())o=a[n()]until not o
return e
end
local function b()local e={t}local o=false
local o=false
local o=false
if t=='0'and H[n()]then
return c(w(e))end
while a[n()]do
r(e,l())end
if n()=="."then
e=x(e)end
local n=n()if S[n]then
e=d(e)end
return c(e)end
local function p()local t={t}local a=h
local o=o
local e=e
local n=1
while true do
local e=o[e+n]if not e or a[e]or e==")"or e==","then break end
n=n+1
r(t,e)end
if n>0 then
l(n-1)end
return c(t)end
local function d()local o,e={},0
local r
repeat
e=e+1
o[e]=t
local e=n()until not(_[e]and l())return c(o)end
local function a()if N(t)then
local n=b()return P(n,e)end
local n=p()return V(n,e)end
local function r()local n=h
local t=o
local r=e
local e
local o=0
while true do
local l=t[r+o]n=n[l]if not n then break end
e=n.value
o=o+1
end
if not e then return end
l(#e-1)return e
end
local function c()local n=t
if U[n]then
return
elseif A[n]then
return y(n,e)elseif F[n]then
return g(d(),e)elseif n==","then
return k(e)else
local n=r()if n then
return E(n,e)end
return a()end
end
local function a()local n,e={},0
local o=t
while o~="\0"do
local r=c()if r then
e=e+1
n[e]=r
end
o=l()end
return n
end
local function r(n,l)if n then
n=n
o=s[n]or m(n)t=o[1]e=1
s[n]=o
end
h=(l and f(l))or T
R=l or u
end
local function e()assert(o,C)i={}local e=a()v()return e
end
return{resetToInitialState=r,run=e}end
return N end)c['Lexer/TokenFactory']=(function(...)local e={}function e.createConstantToken(n,e)return{TYPE="Constant",Value=n,Position=e}end
function e.createVariableToken(n,e)return{TYPE="Variable",Value=n,Position=e}end
function e.createParenthesesToken(e,n)return{TYPE="Parentheses",Value=e,Position=n}end
function e.createOperatorToken(n,e)return{TYPE="Operator",Value=n,Position=e}end
function e.createCommaToken(e)return{TYPE="Comma",Value=",",Position=e}end
function e.createStrToken(n,e)return{TYPE="String",Value=n,Position=e}end
return e end)c['Parser/Parser']=(function(...)local n=a("Helpers/Helpers")local e=a("Parser/NodeFactory")local u=n.stringToTable
local T=table.insert
local n=table.concat
local s=math.max
local F=math.min
local f=string.rep
local Y=e.createUnaryOperatorNode
local L=e.createOperatorNode
local S=e.createFunctionCallNode
local a=20
local O="No tokens given"local P="No tokens to parse"local v="Expected EOF, got '%s'"local g="Unexpected token: '%s' in <primary>, expected constant, variable or function call"local i="Expected expression, got EOF"local m="Expected ')', got EOF"local k="Expected ',' or ')', got '%s'"local c="<No charStream, error message: %s>"local p={Unary={["-"]=7,["!"]=7,},Binary={[":="]=1,["&&"]=2,["||"]=3,["=="]=4,["!="]=4,[">"]=4,["<"]=4,[">="]=4,["<="]=4,["+"]=5,["-"]=5,["*"]=6,["/"]=6,["%"]=6,["^"]=7,},RightAssociativeBinaryOperators={["^"]=true},}local e={}local function V(t,l,o,n)local r,e
if t then
r=o or 1
e=t[r]end
local l=l or p
local d=n
local function h(e)return t[r+(e or 1)]end
local function n(n)local n=r+(n or 1)local o=t[n]r=n
e=o
return o
end
local function y(n)local e=n or e
if not l.Binary then return end
return e and e.TYPE=="Operator"and l.Binary[e.Value]end
local function b(n)local e=n or e
if not l.Unary then return end
return e and e.TYPE=="Operator"and l.Unary[e.Value]end
local function x(n)local e=n or e
if not l.RightAssociativeBinaryOperators then return end
return e and e.TYPE=="Operator"and l.RightAssociativeBinaryOperators[e.Value]end
local function V()local n=h()if not n then return end
return e.TYPE=="Variable"and n.TYPE=="Parentheses"and n.Value=="("end
local function E(e)return e and l.Binary[e.Value]end
local function o(o,...)if not d then
return c:format(o)end
local n=u(d)local l=o:format(...)local e=(not e and#n+1)or e.Position
local o={}for e=s(1,e-a),F(e+a,#n)do
T(o,n[e])end
local n=table.concat(o)local e=f(" ",e-1).."^"return"\n"..n.."\n"..e.."\n"..l
end
local s,u,c,f,a
function s()local r=e.Value
n(2)local l={}while true do
local r=a()T(l,r)if not e then
local e=h(-1)if e.TYPE=="Comma"then
error(o(i))end
error(o(m))elseif e.Value==")"then
break
elseif e.TYPE=="Comma"then
n()else
error(o(k,e.Value))end
end
n()return S(r,l)end
function u(t)local l=c()while y(e)do
local r=E(e)if r<=t and not x(e)then
break
end
local t=e
if not n()then
error(o(i))end
local e=u(r)l=L(t.Value,l,e)end
return l
end
function c()if not b(e)then
return f()end
local l=e.Value
if not n()then
error(o(i))end
local e=c()return Y(l,e)end
function f()local l=e
if not l then return end
local t=l.Value
local r=l.TYPE
if r=="Parentheses"and t=="("then
n()local l=a()if not e or e.Value~=")"then
error(o(m))end
n()return l
elseif r=="Variable"then
if V()then
return s()end
n()return l
elseif r=="Constant"or r=="String"then
n()return l
end
error(o(g,t))end
function a()local e=u(0)return e
end
local function c(n,o,a,c)assert(n,O)t=n
r=a or 1
e=n[r]l=o or p
d=c
end
local function n(n)assert(t,P)local l=a()if e and not n then
error(o(v,e.Value))end
return l
end
return{resetToInitialState=c,parse=n}end
return V end)c['Parser/NodeFactory']=(function(...)local e={}function e.createUnaryOperatorNode(e,n)return{TYPE="UnaryOperator",Value=e,Operand=n}end
function e.createOperatorNode(n,o,e)return{TYPE="Operator",Value=n,Left=o,Right=e}end
function e.createFunctionCallNode(n,e)return{TYPE="FunctionCall",FunctionName=n,Arguments=e}end
return e end)c['MathParser']=(function(...)local e=a("Helpers/Helpers")local c=a("Evaluator/Evaluator")local u=a("Lexer/Lexer")local i=a("Parser/Parser")local e={}function e:tokenize(e)if self.cachedTokens[e]then
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
function e:addVariable(n,e)self.variables=self.variables or{}self.variables[n]=e
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
function e:resetToInitialState(e,n,l,o,r)self.operatorPrecedenceLevels=e
self.variables=n
self.operatorFunctions=l
self.operators=o
self.functions=r
self.cachedTokens={}self.cachedASTs={}self.cachedResults={}end
local r={}function r:new(l,o,r,a,t)local n={}for e,l in pairs(e)do
n[e]=l
end
o=o or{}o['false']=false
o['true']=true
n.operatorPrecedenceLevels=l
n.variables=o
n.operatorFunctions=r
n.operators=a
n.functions=t
n.cachedTokens={}n.cachedASTs={}n.cachedResults={}n.Lexer=u(nil,a)n.Parser=i(nil,l)n.Evaluator=c(nil,o,r,t)return n
end
return r end)local n,e="LibFormula-1.0",1
local n,e=LibStub and LibStub:NewLibrary(n,e)or{}if not n then return end
local e={}function n:CreateInstance()return e:new()end
local o=a('MathParser')function e:new()local e=setmetatable({__vm=o:new()},{__index=self})assert(e.__vm,'Invalid instance object')return e
end
function e:addFunc(e,n)self.__vm:addFunction(e,n)end
function e:exec(e)return self.__vm:evaluate(e)end
function e:parse(e)return self.__vm:parse(self.__vm:tokenize(e),e)end
function e:perform(e)return self.__vm:solve(e)end
return n
