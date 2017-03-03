Include("\\script\\test2.lua") --or Require("\\script\\test2.lua") or dofile("\\script\\test2.lua") later you can custom this keyword 
main()
test2.lua

function main()
end
// register lua engine  
CCLuaEngine* pEngine = CCLuaEngine::defaultEngine();  
CCScriptEngineManager::sharedManager()->setScriptEngine(pEngine);  
  
std::string path = CCFileUtils::sharedFileUtils()->fullPathForFilename("hello.lua");  
pEngine->executeScriptFile(path.c_str());  
print ("hello")
movep 