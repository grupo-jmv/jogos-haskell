{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE QuasiQuotes #-}
module Handler.JogoRemover where
import Import
import Database.Persist.Postgresql

postJogoRemoverR :: JogoId -> Handler Html
postJogoRemoverR pid = do
    runDB $ delete pid
    redirect JogosR