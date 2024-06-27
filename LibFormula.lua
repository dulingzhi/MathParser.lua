local c={}local r={}local o={}local function a(e)local n=r[e]if n then
return n
end
if o[e]then
error('critical dependency',2)end
o[e]=true
n=c[e]()o[e]=false
r[e]=n
return n
end
c['Helpers/Helpers']=(function(...)local t=string.char
local l=string.match
local a=string.gmatch
local c=table.insert
local o=string.utf8len or string.len
local r=string.utf8sub or string.sub
local n={}function n.stringToTable(n)local e={}for o=1,o(n)do
local n=r(n,o,o)c(e,n)end
return e
end
function n.createPatternLookupTable(o)local e={}for n=0,255 do
local n=t(n)if l(n,o)then
e[n]=true
end
end
return e
end
function n.makeTrie(e)local o={}for e,r in ipairs(e)do
local e=o
for n in a(r,".")do
e[n]=e[n]or{}e=e[n]end
e.value=r
end
return o
end
return n end)c['Evaluator/Evaluator']=(function(...)local e=a("Helpers/Helpers")local h=(unpack or table.unpack)local p=table.insert
local d={Unary={["-"]=function(e)return-e end,["!"]=function(e)return not e end,},Binary={["+"]=function(e,n)return e+n end,["-"]=function(e,n)return e-n end,["/"]=function(e,n)return e/n end,["*"]=function(e,n)return e*n end,["^"]=function(n,e)return n^e end,["%"]=function(e,n)return e%n end,["=="]=function(n,e)return n==e end,["!="]=function(n,e)return n~=e end,[">"]=function(e,n)return e>n end,["<"]=function(e,n)return e<n end,[">="]=function(e,n)return e>=n end,["<="]=function(n,e)return n<=e end,["||"]=function(n,e)return not not n or not not e end,["||||"]=function(e,n)return not not e or not not n end,["&&"]=function(e,n)return not not(e and n)end,[":="]=function(n,o,r,e)e[n]=o end,}}local u={sin=math.sin,cos=math.cos,tan=math.tan,asin=math.asin,acos=math.acos,atan=math.atan,floor=math.floor,ceil=math.ceil,abs=math.abs,sqrt=math.sqrt,log=math.log,log10=math.log10,exp=math.exp,rad=math.rad,deg=math.deg}local function f(n,e,o,a)local t=n
local l=e or{}local r=o or d
local a=a or{}local n,s,i,c,o
function n(e)local l=e.Value
local n=r.Unary[l]assert(n,"invalid operator: "..tostring(l))local o=o(e.Operand)return n(o,e)end
function s(e)local n=e.Value
local t=e.Left
local a=e.Right
local n=r.Binary[n]assert(n,"invalid operator")local r=o(t)local o=o(a)return n(r,o,e,l)end
function i(e)local o=not(not e.Operand)if o then
return n(e)end
return s(e)end
function c(n)local e=n.FunctionName
local r=n.Arguments
local n=a[e]or u[e]assert(n,"invalid function call: "..tostring(e))local e={}for r,n in ipairs(r)do
local n=o(n)p(e,n)end
return n(h(e))end
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
local function i(o,c,n,e)t=o
l=c or{}r=n or d
a=e or u
end
local function e()assert(t,"No expression to evaluate")return o(t)end
return{resetToInitialState=i,evaluate=e}end
return f end)c['Lexer/Lexer']=(function(...)local e=a("Helpers/Helpers")local n=a("Lexer/TokenFactory")local p=e.makeTrie
local b=e.stringToTable
local e=e.createPatternLookupTable
local c=table.concat
local l=table.insert
local P=string.rep
local v=n.createConstantToken
local x=n.createVariableToken
local g=n.createParenthesesToken
local E=n.createOperatorToken
local k=n.createCommaToken
local V=n.createStrToken
local h="+------------------------------+"local O="Expected a number after the 'x' or 'X'"local y="Expected a number after the decimal point"local _="Expected a number after the exponent sign"local n="Invalid character '%s'. Expected whitespace, parenthesis, comma, operator, or number."local R="No charStream given"local f={"+","-","*","/","^","%","==","!","!=",">","<",">=","<=","||","||||",'&&',":=",}local m=p(f)local A=e("%s")local a=e("%d")local U=e("[a-zA-Z_%.]")local T=e("[%da-fA-F]")local C=e("[+-]")local Y=e("[eE]")local N=e("[xX]")local F=e("[a-zA-Z0-9_%.]")local S=e("[()]")local function L(n,r,u)local s={}local i={}local o,t,e
if n then
n=n
o=b(n)t=o[u or 1]e=u or 1
s[n]=o
end
local n=(r and p(r))or m
local L=r or f
local u=n
local function n()return o[e+1]or"\0"end
local function r(n)local n=e+(n or 1)local o=o[n]or"\0"e=n
t=o
return o
end
local function d(r,n)local e=e+(n or 0)local e=P(" ",e-1).."^"local e="\n"..c(o).."\n"..e.."\n"..r
return e
end
local function w()local e=i
if#e>0 then
local e=c(e,"\n"..h)error("Lexer errors:".."\n"..h..e.."\n"..h)end
end
local function H(e)local e=(e or t)return a[e]or(e=="."and a[n()])end
local function h(o)l(o,r())local e=T[n()]if not e then
local e=d(O,1)l(i,e)end
repeat
l(o,r())e=T[n()]until not e
return o
end
local function T(e)l(e,r())local o=a[n()]if not o then
local e=d(y,1)l(i,e)end
repeat
l(e,r())o=a[n()]until not o
return e
end
local function y(e)l(e,r())if C[n()]then
l(e,r())end
local o=a[n()]if not o then
local e=d(_,1)l(i,e)end
repeat
l(e,r())o=a[n()]until not o
return e
end
local function P()local e={t}local o=false
local o=false
local o=false
if t=='0'and N[n()]then
return c(h(e))end
while a[n()]do
l(e,r())end
if n()=="."then
e=T(e)end
local n=n()if Y[n]then
e=y(e)end
return c(e)end
local function T()local t={t}local a=u
local o=o
local e=e
local n=1
while true do
local e=o[e+n]if not e or a[e]or e==")"or e==","then break end
n=n+1
l(t,e)end
if n>0 then
r(n-1)end
return c(t)end
local function h()local o,e={},0
local l
repeat
e=e+1
o[e]=t
local e=n()until not(F[e]and r())return c(o)end
local function d()if H(t)then
local n=P()return v(n,e)end
local n=T()return V(n,e)end
local function a()local n=u
local t=o
local l=e
local e
local o=0
while true do
local r=t[l+o]n=n[r]if not n then break end
e=n.value
o=o+1
end
if not e then return end
r(#e-1)return e
end
local function c()local n=t
if A[n]then
return
elseif S[n]then
return g(n,e)elseif U[n]then
return x(h(),e)elseif n==","then
return k(e)else
local n=a()if n then
return E(n,e)end
return d()end
end
local function a()local l,e={},0
local o=t
while o~="\0"do
local n=c()if n then
e=e+1
l[e]=n
end
o=r()end
return l
end
local function l(n,r)if n then
n=n
o=s[n]or b(n)t=o[1]e=1
s[n]=o
end
u=(r and p(r))or m
L=r or f
end
local function e()assert(o,R)i={}local e=a()w()return e
end
return{resetToInitialState=l,run=e}end
return L end)c['Lexer/TokenFactory']=(function(...)local e={}function e.createConstantToken(n,e)return{TYPE="Constant",Value=n,Position=e}end
function e.createVariableToken(n,e)return{TYPE="Variable",Value=n,Position=e}end
function e.createParenthesesToken(e,n)return{TYPE="Parentheses",Value=e,Position=n}end
function e.createOperatorToken(n,e)return{TYPE="Operator",Value=n,Position=e}end
function e.createCommaToken(e)return{TYPE="Comma",Value=",",Position=e}end
function e.createStrToken(n,e)return{TYPE="String",Value=n,Position=e}end
return e end)c['Parser/Parser']=(function(...)local n=a("Helpers/Helpers")local e=a("Parser/NodeFactory")local d=n.stringToTable
local h=table.insert
local n=table.concat
local T=math.max
local F=math.min
local m=string.rep
local Y=e.createUnaryOperatorNode
local L=e.createOperatorNode
local S=e.createFunctionCallNode
local a=20
local y="No tokens given"local k="No tokens to parse"local v="Expected EOF, got '%s'"local E="Unexpected token: '%s' in <primary>, expected constant, variable or function call"local u="Expected expression, got EOF"local p="Expected ')', got EOF"local P="Expected ',' or ')', got '%s'"local i="<No charStream, error message: %s>"local f={Unary={["-"]=7,["!"]=7,},Binary={[":="]=1,["&&"]=2,["||"]=3,["||||"]=3,["=="]=4,["!="]=4,[">"]=4,["<"]=4,[">="]=4,["<="]=4,["+"]=5,["-"]=5,["*"]=6,["/"]=6,["%"]=6,["^"]=7,},RightAssociativeBinaryOperators={["^"]=true},}local e={}local function x(t,o,r,n)local l,e
if t then
l=r or 1
e=t[l]end
local r=o or f
local c=n
local function s(e)return t[l+(e or 1)]end
local function n(n)local n=l+(n or 1)local o=t[n]l=n
e=o
return o
end
local function V(n)local e=n or e
if not r.Binary then return end
return e and e.TYPE=="Operator"and r.Binary[e.Value]end
local function b(n)local e=n or e
if not r.Unary then return end
return e and e.TYPE=="Operator"and r.Unary[e.Value]end
local function g(n)local e=n or e
if not r.RightAssociativeBinaryOperators then return end
return e and e.TYPE=="Operator"and r.RightAssociativeBinaryOperators[e.Value]end
local function x()local n=s()if not n then return end
return e.TYPE=="Variable"and n.TYPE=="Parentheses"and n.Value=="("end
local function O(e)return e and r.Binary[e.Value]end
local function o(o,...)if not c then
return i:format(o)end
local n=d(c)local r=o:format(...)local e=(not e and#n+1)or e.Position
local o={}for e=T(1,e-a),F(e+a,#n)do
h(o,n[e])end
local n=table.concat(o)local e=m(" ",e-1).."^"return"\n"..n.."\n"..e.."\n"..r
end
local m,i,d,T,a
function m()local t=e.Value
n(2)local r={}while true do
local l=a()h(r,l)if not e then
local e=s(-1)if e.TYPE=="Comma"then
error(o(u))end
error(o(p))elseif e.Value==")"then
break
elseif e.TYPE=="Comma"then
n()else
error(o(P,e.Value))end
end
n()return S(t,r)end
function i(t)local r=d()while V(e)do
local l=O(e)if l<=t and not g(e)then
break
end
local e=e
if not n()then
error(o(u))end
local n=i(l)r=L(e.Value,r,n)end
return r
end
function d()if not b(e)then
return T()end
local r=e.Value
if not n()then
error(o(u))end
local e=d()return Y(r,e)end
function T()local r=e
if not r then return end
local t=r.Value
local l=r.TYPE
if l=="Parentheses"and t=="("then
n()local r=a()if not e or e.Value~=")"then
error(o(p))end
n()return r
elseif l=="Variable"then
if x()then
return m()end
n()return r
elseif l=="Constant"or l=="String"then
n()return r
end
error(o(E,t))end
function a()local e=i(0)return e
end
local function i(n,i,o,a)assert(n,y)t=n
l=o or 1
e=n[l]r=i or f
c=a
end
local function l(n)assert(t,k)local r=a()if e and not n then
error(o(v,e.Value))end
return r
end
return{resetToInitialState=i,parse=l}end
return x end)c['Parser/NodeFactory']=(function(...)local e={}function e.createUnaryOperatorNode(n,e)return{TYPE="UnaryOperator",Value=n,Operand=e}end
function e.createOperatorNode(n,e,o)return{TYPE="Operator",Value=n,Left=e,Right=o}end
function e.createFunctionCallNode(e,n)return{TYPE="FunctionCall",FunctionName=e,Arguments=n}end
return e end)c['MathParser']=(function(...)local e=a("Helpers/Helpers")local u=a("Evaluator/Evaluator")local c=a("Lexer/Lexer")local i=a("Parser/Parser")local e={}function e:tokenize(e)if self.cachedTokens[e]then
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
function e:addFunction(e,n)self.functions=self.functions or{}self.functions[e]=n
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
function e:resetToInitialState(r,l,o,n,e)self.operatorPrecedenceLevels=r
self.variables=l
self.operatorFunctions=o
self.operators=n
self.functions=e
self.cachedTokens={}self.cachedASTs={}self.cachedResults={}end
local r={}function r:new(r,o,l,a,t)local n={}for e,r in pairs(e)do
n[e]=r
end
o=o or{}o['false']=false
o['true']=true
n.operatorPrecedenceLevels=r
n.variables=o
n.operatorFunctions=l
n.operators=a
n.functions=t
n.cachedTokens={}n.cachedASTs={}n.cachedResults={}n.Lexer=c(nil,a)n.Parser=i(nil,r)n.Evaluator=u(nil,o,l,t)return n
end
return r end)local e,n="LibFormula-1.0",1
local n,e=LibStub and LibStub:NewLibrary(e,n)or{}if not n then return end
local e={}function n:CreateInstance()return e:new()end
local o=a('MathParser')function e:new()local e=setmetatable({__vm=o:new()},{__index=self})assert(e.__vm,'Invalid instance object')return e
end
function e:addFunc(e,n)self.__vm:addFunction(e,n)end
function e:exec(e)return self.__vm:evaluate(e)end
function e:parse(e)return self.__vm:parse(self.__vm:tokenize(e),e)end
function e:perform(e)return self.__vm:solve(e)end
return n
