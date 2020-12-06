{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE QuasiQuotes #-}
module Handler.Desenvolvedora where
import Import
import Database.Persist.Postgresql

getDesenvolvedoraR :: Handler Html 
getDesenvolvedoraR = do 
    (widget, _) <- generateFormPost formDesenvolvedora
    defaultLayout $ do 
        $(whamletFile "templates/desenvolvedora.hamlet")

postDesenvolvedoraR :: Handler Html
postDesenvolvedoraR = do
    ((result,_),_) <- runFormPost formDesenvolvedora
    case result of 
        FormSuccess desenvolvedora -> do
            runDB $ insert desenvolvedora 
            setMessage [shamlet|
                <div>
                    Desenvolvedora adicionada
            |]
            redirect DesenvolvedorasR
        _ -> redirect HomeR

formDesenvolvedora :: Form Desenvolvedora
formDesenvolvedora = renderBootstrap $ Desenvolvedora
   <$> areq textField "Nome: " Nothing