{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE QuasiQuotes #-}
module Handler.Jogo where
import Import
import Database.Persist.Postgresql

getJogoR :: Handler Html 
getJogoR = do 
    (widget, _) <- generateFormPost formJogo
    defaultLayout $ do 
        $(whamletFile "templates/jogo.hamlet")

postJogoR :: Handler Html
postJogoR = do
    ((result,_),_) <- runFormPost formJogo
    case result of 
        FormSuccess jogo -> do
            runDB $ insert jogo 
            setMessage [shamlet|
                <div>
                    jogo adicionado
            |]
            redirect JogosR
        _ -> redirect HomeR

formJogo :: Form Jogo
formJogo = renderBootstrap $ Jogo
   <$> areq textField "Nome: " Nothing
   <*> areq dayField "Lançamento: " Nothing
   <*> areq (selectField desenvolvedoras) "Desenvolvedora: " Nothing

desenvolvedoras = do
    rows <- runDB $ selectList [] [Asc DesenvolvedoraNome]
    optionsPairs $
        map (\r -> (desenvolvedoraNome $ entityVal r, entityKey r)) rows