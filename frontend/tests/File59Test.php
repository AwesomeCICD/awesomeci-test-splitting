<?php
use PHPUnit\Framework\TestCase;
use Demo\File59;

class File59Test extends TestCase {
    public function testAdd() {
        $this->assertEquals(5, File59::add(2, 3));
    }
}
