/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dao;

import com.pojo.Products;
import com.util.invUtil;
import java.util.ArrayList;
import java.util.List;
import org.hibernate.Query;
import org.hibernate.Session;
import org.hibernate.Transaction;
/**
 *
 * @author ASUS
 */
public class ProductsDAO {
    public List<Products> getAll(){
        List<Products> prodList = new ArrayList<Products>();
        Transaction trans = null;
        Session session = invUtil.getSessionFactory().openSession();
        try{
            trans = session.beginTransaction();
            Query query = session.createQuery("from Products");
            prodList = query.list();
            trans.commit();
        } catch (Exception e){
            System.out.println(e);
        }
        session.close();
        return prodList;
    }   
    
    public List<Products> getById(Integer id){
        List<Products> prodList = new ArrayList();
        Products prod = new Products();
        Transaction trans = null;
        Session session = invUtil.getSessionFactory().openSession();
        
        try{
            trans = session.beginTransaction();
            Query query = session.createQuery("from Products where id=:id");
            query.setInteger("id",id);
            prod = (Products) query.uniqueResult();
            prodList = query.list();
            trans.commit();
        } catch(Exception e){
            System.out.println(e);
        }
        session.close();
        return prodList;
    }
    
    public void add(Products product){
        Transaction trans = null;
        Session session = invUtil.getSessionFactory().openSession();
        try {
            trans = session.beginTransaction();
            session.save(product);
            trans.commit(); 
        } catch (Exception e){
            System.out.println(e);
        }
        session.close();
    }
    
    public void delete(Integer id){
        Transaction trans = null;
        Session session = invUtil.getSessionFactory().openSession();
        
        try{
            trans = session.beginTransaction();
            Products product = (Products) session.load(Products.class, new Integer(id));
            session.delete(product);
            trans.commit();
        }catch (Exception e){
            System.out.println(e);
        }
        session.close();
    }
    
    public void edit(Products product){
        Transaction trans = null;
        Session session = invUtil.getSessionFactory().openSession();
        
        try{
            trans = session.beginTransaction();
            session.update(product);
            trans.commit();
        }catch (Exception e){
            System.out.println(e);
        }
        session.close();
    }
}
